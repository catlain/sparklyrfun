package Sparklyrfun

import org.apache.spark.ml.linalg.{DenseVector, SparseVector, Vector, Vectors}
import org.apache.spark.sql.{DataFrame, SparkSession}
import org.apache.spark.sql.functions._

import scala.collection.mutable.ArrayBuffer


  /* object name need TOUPPPER ??!!! */

object MyUdfs {
    /**
    * 
    * @param aidVec
    * @param pkgVec
    * @param tarpkg
    */
  def getRank(aidVec:DataFrame, pkgVec:DataFrame, aidVecCol:String = "aidarrayrun_vec", pkgVecCol:String = "runapp_vec", aidCol:String = "aid", tarpkg:String = "com.cmcm.live") = {
    val pkgVec1 = pkgVec.filter(col(pkgVecCol) === tarpkg).collect()(0).
      getAs[SparseVector](pkgVecCol).toArray

    val aidVec1 = aidVec.collect()(0).getAs[SparseVector](aidVecCol)


    val udf1 = udf((runapp_vec: SparseVector, pkgVecArr:Seq[Double]) => {
      val elemWiseProd: Array[Double] = runapp_vec.toArray.zip(pkgVecArr.toArray[Double]).map(entryTuple => entryTuple._1 * entryTuple._2)
      elemWiseProd.sum
    })
    
    aidVec.select(col(aidCol), col(aidVecCol)).
    withColumn("pkgVecArr",lit(pkgVec1)).
    select(udf1(col(pkgVecCol), col("pkgVecArr")).alias("rank")) //udf case array => wrapped array
  }
      /**
      *
      * @param df
      * @param inputCol
      * @param outputCol
      * @return
      */
    def vectorToArray(df:DataFrame, inputCol:String, outputCol:String) = {
      val vectorToSeqUDF = udf((V:Vector) => V.toArray)
      df.withColumn(outputCol, vectorToSeqUDF(col(inputCol)))
  
    }
  
  
  /**
    *
    * @param df
    * @param inputCol
    * @param outputCol
    * @param numDot
    * @return
    */
    def vectorDotVector(df:DataFrame, inputCol:String, outputCol:String, numDot:Int) = {
    //   def dotVec(inputVec:Vector) = {
    //     //  V.flatMap(x => for (y <- V) yield if(x != y) x*y else None).filter(_ != None).toVector
    //     var n = 0
    //     val outputVec = for (x <- inputVec.toArray) yield {
    //       n += 1
    //       for {
    //         y <- inputVec.toArray.drop(n)
    //       }
    //         yield x * y
    //     }
    //     Vectors.dense(outputVec.flatten)
    //   }
    
        val dotVecUDF =  udf((inputVec:Vector) => {
          var inputVecSize = inputVec.size
          if (numDot > inputVecSize - 1) {
            val num_dot = inputVecSize - 1
            printf("num_dot > inputVec.size and reduce to" + inputVec.size)
          }
          val vecArr:Array[Int] = 1.to(inputVecSize).toArray
    
          val outputVec = vecArr.combinations(numDot).toArray.map(_.map(inputVec(_)).reduce(_ * _))
          Vectors.dense(outputVec)
        })
        
      // val dotVecUDF = udf(dotVec(inputVec,numDot))
      df.withColumn(outputCol, dotVecUDF(col(inputCol)))
    }


}