package SparklyrFun

/**
  * Created by xuyang on 2017/5/2.
*/

import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.Column

object getArray {
  def getItem1(col: Column)  = {
    col.getItem(0)
  }
}
