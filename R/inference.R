#' Method of Moments Estimator for gamma dist.
#'
#' search_point function will calculate mom estimate for the shape parameter "k" and the scale parameter "theta" by using given sample.
#'
#' @import rJava
#' @import DBI
#' @import RJDBC
#'
#' @param clientid the given sample to calculate the estimate of the parameters.
#' @return data.frame
#' @examples
#' clientid <- '00000220d02544fffefbc4bf'
#' search_point(clientid)
#' @export

search_point <- function(clientid) {

  require(DBI)
  require(rJava)
  require(RJDBC)

	hive.class.path = list.files(path=c("/apps/hive/lib"), pattern="jar", full.names=T)
	hadoop.lib.path = list.files(path=c("/apps/hadoop/lib"), pattern="jar", full.names=T)
	hadoop.class.path = list.files(path=c("/apps/hadoop"), pattern="jar", full.names=T)
	class.path = c(hive.class.path, hadoop.lib.path, hadoop.class.path);
	.jinit(classpath = class.path)

	drv <- JDBC("org.apache.hive.jdbc.HiveDriver", "/Users/syjung/Downloads/hive-jdbc-3.1.0.3.1.4.6-1-standalone.jar", identifier.quote="'")
	conn <- dbConnect(drv, "jdbc:hive2://192.168.7.164:10000/default","hive", " !Hive1357")

  query <- sprintf("select * from p_point_data_h where sClientId = '%s'", clientid)
	query_data <- dbGetQuery(conn, query)
	queryData <- as.data.frame(query_data)
	return(queryData)
}
