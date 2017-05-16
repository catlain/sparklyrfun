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
  def getRank(aidVec:DataFrame, pkgVec:DataFrame, aidVecCol:String = "runapp_vec", pkgVecCol:String = "aidarrayrun_vec", aidCol:String = "aid", pkgCol:String = "runpkg", tarpkg:String = "com.cmcm.live") = {
    
    val pkgVecTarget = pkgVec.filter(col(pkgCol) === tarpkg).collect()(0).
      getAs[SparseVector](pkgVecCol).toArray

    val udf1 = udf((runapp_vec: SparseVector, pkgVecArr:Seq[Double]) =>{
      val elemWiseProd: Array[Double] = runapp_vec.toArray.zip(pkgVecArr.toArray[Double]).map(entryTuple => entryTuple._1 * entryTuple._2) //udf case array => wrapped array
      elemWiseProd.sum
    })
    
    aidVec.select(col(aidCol), col(aidVecCol)).
    withColumn("pkgVecArr",lit(pkgVecTarget)).
    select(udf1(col(aidVecCol), col("pkgVecArr")).alias("rank")) 
  }
}

 