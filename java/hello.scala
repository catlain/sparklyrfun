package Sparklyrfun

import org.apache.spark.ml.linalg.{DenseVector, SparseVector, Vector}
import org.apache.spark.sql.{DataFrame, SparkSession, Column}
import org.apache.spark.sql.functions._

object udfs {
  /**
    *
    * @param aidVec
    * @param pkgVec
    * @param aidVecCol
    * @param pkgVecCol
    * @param aidCol
    * @param pkgCol
    * @param tarpkg
    * @return
    */
  def getRank(aidVec:DataFrame, pkgVec:DataFrame, aidVecCol:String = "runapp_vec", pkgVecCol:String = "aidarrayrun_vec", aidCol:String = "aid", pkgCol:String = "runpkg", tarpkg:String = "com.cmcm.live") = {

    val pkgVecTarget = pkgVec.filter(col(pkgCol) === tarpkg).collect()(0).
      getAs[SparseVector](pkgVecCol).toArray

    val udf1 = udf((runapp_vec: SparseVector, pkgVecArr:Seq[Double]) =>{
      val elemWiseProd: Array[Double] = runapp_vec.toArray.zip(pkgVecArr.toArray[Double]).map(entryTuple => entryTuple._1 * entryTuple._2) //udf case array => wrapped array
      elemWiseProd.sum
    })

    aidVec.select(col(aidCol), col(aidVecCol)).
      withColumn("pkgVecArr",lit(pkgVecTarget)).
      select(col(aidCol), udf1(col(aidVecCol), col("pkgVecArr")).alias("rank"))
  }

  /**
    *
    * @param df
    * @param inputCol
    * @param outputCol
    * @return
    */
  def VectorToSeq(df:DataFrame, inputCol:String, outputCol:String) = {

    val VectorToSeqUDF = udf((V:Vector) => V.toArray)
    df.withColumn(outputCol, VectorToSeqUDF(col(inputCol)))

  }


}


 