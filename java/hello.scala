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
  def getRank(aidVec:DataFrame, pkgVec:DataFrame, tarpkg:String) = {
    val pkgVec1 = pkgVec.filter(col("runpkg") === tarpkg).collect()(0).
      getAs[SparseVector]("aidarrayrun_vec").toArray

    val aidVec1 = aidVec.collect()(0).getAs[SparseVector]("runapp_vec")


    val udf1 = udf((runapp_vec: SparseVector, pkgVecArr:Seq[Double]) =>{
      val elemWiseProd: Array[Double] = runapp_vec.toArray.zip(pkgVecArr.toArray[Double]).map(entryTuple => entryTuple._1 * entryTuple._2)
      elemWiseProd.sum
    })

    val cfRank = aidVec.select(col("aid"), col("runapp_vec")).withColumn("pkgVecArr",lit(pkgVec1)).
      select(udf1(col("runapp_vec"), col("pkgVecArr")).alias("rank")) //udf case array => wrapped array
  }
}

 