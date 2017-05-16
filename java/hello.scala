package Sparklyrfun

import org.apache.spark.ml.linalg.{DenseVector, SparseVector, Vector}
import org.apache.spark.sql.{DataFrame, SparkSession, Column}
import org.apache.spark.sql.functions._

object CF {
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


    val udf1 = udf((runapp_vec: SparseVector, pkgVecArr:Seq[Double]) =>{
      val elemWiseProd: Array[Double] = runapp_vec.toArray.zip(pkgVecArr.toArray[Double]).map(entryTuple => entryTuple._1 * entryTuple._2)
      elemWiseProd.sum
    })
    
    aidVec.select(col(aidCol), col(aidVecCol)).
    withColumn("pkgVecArr",lit(pkgVec1)).
    select(udf1(col(pkgVecCol), col("pkgVecArr")).alias("rank")) //udf case array => wrapped array
  }
}

 