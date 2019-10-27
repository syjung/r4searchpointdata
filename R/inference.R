#' Method of Moments Estimator for gamma dist.
#'
#' search_point function will calculate mom estimate for the shape parameter "k" and the scale parameter "theta" by using given sample.
#'
#' @import rJava
#' @import DBI
#' @import RJDBC
#'
#' @param sclist : client list
#' @param from : start date
#' @param  ... : end date
#' @return data.frame
#' @examples
#' sclist <- c('00000220d02544fffefbc4bf', '00000220d02544fffefc768c');
#' search_point(sclist, '2019-09-01', '2019-09-12')
#' @export

search_point <- function(sclist, from, ...) {

  prequery <- "select sclientid, ddate, skey, sval from p_point_data_h where"

  incaluse <- paste("'", paste(sclist, collapse = "','"), "'", sep = "")
  midquery <- sprintf("sclientid in (%s) and", incaluse)

  args <- list(...)
  if ( length(args) == 1 ) {
    query <- sprintf("%s %s to_date(ddate) between '%s' and '%s'", prequery, midquery, from, args[1])
  } else {
    query <- sprintf("%s %s to_date(ddate) >= '%s'", prequery, midquery, from)
  }
  print(query)
  hive.class.path = list.files(path=c("/apps/hive/lib"), pattern="jar", full.names=T)
  hadoop.lib.path = list.files(path=c("/apps/hadoop/lib"), pattern="jar", full.names=T)
  hadoop.class.path = list.files(path=c("/apps/hadoop"), pattern="jar", full.names=T)
  class.path = c(hive.class.path, hadoop.lib.path, hadoop.class.path);
  .jinit(classpath = class.path)

  drv <- JDBC("org.apache.hive.jdbc.HiveDriver", "/Users/syjung/Downloads/hive-jdbc-3.1.0.3.1.4.6-1-standalone.jar", identifier.quote="'")
  conn <- dbConnect(drv, "jdbc:hive2://192.168.7.164:10000/default","hive", " !Hive1357")

  query_data <- dbGetQuery(conn, query)
  return(query_data)
}
