/**
 * mysql.nut
 *
 * Класс MySQL
 * @author mabako
 * @editor Jonathan_Rosewood <jonathan-rosewood@yandex.ru>
 *
 * Description:
 * - File modifed for gamemode
 *
 */

class mysql
{
	handler = false;
	hostname = "";
	username = "";
	password = "";
	database = "";

	constructor(hostname, username, password, database) {
		this.hostname = hostname;
		this.username = username;
		this.password = password;
		this.database = database;
//		connect();
	}

	// Connect to MySQL Server
	function connect() {
		handler = mysql_connect(hostname, username, password, database);
		if(connected()) return handler != false;
	}

	// Check connection to MySQL Server
	function connected() {
		if(!handler || !mysql_ping(handler)) return connect();
		return true;
	}

	// Disconnect from MySQL Server
	function disconnect() {
		if(connected()) {
			mysql_close(handler);
			handler = false;
		}
	}

	// Print MySQL Server error to iv-mp server console
	function error() {
		if(mysql_errno(handler) > 0)
			log("[MySQL] Error: "+mysql_errno(handler).tostring()+" "+mysql_error(handler));
	}

	// Escape string for safe use with MySQL
	function escape(string) {
		if(connected())
			return mysql_escape_string(handler, string);
	}

	// Execute query
	function query(string) {
		if(connected()) {
			local result = mysql_query(handler, string);
			if(result) {
				mysql_free_result(result);
				return true;
			}
			else error();
		}
		return false;
	}
	
	// Execute query and return inserted ID
	function query_insertid(string) {
		if(connected) {
			local result = mysql_query(handler, string);
			if(result) {
				mysql_free_result(result);
				return mysql_insert_id(handler);
			}
			else error();
		}
		return false;
	}
	
	// Returns an array containing a key = value table for all results returned by the query
	function query_assoc(string) {
		if(connected()) {
			local result = mysql_query(handler, string);
			if(result) {
				local rows = [];
				local row = null;
				while(row = mysql_fetch_assoc(result)) {
					rows.push(row);
				}
				mysql_free_result(result);
				return rows;
			}
			else error();
		}
		return false;
	}
	
	// Returns a single row for a MySQL Query Result, false on error or if no such result exists
	function query_assoc_single(string) {
		if(connected()) {
			local result = mysql_query(handler, string);
			if(result) {
				local row = mysql_fetch_assoc(result);
				if(row) {
					mysql_free_result(result);
					return row;
				}
				return false;
			}
			else error();
		}
		return false;
	}
	
	// Executes a query and returns the number of affected rows - selected, deleted, modified etc.
	function query_affected_rows(string) {
		if(connected()) {
			local result = mysql_query(handler, string);
			if(result) {
				local rows = mysql_affected_rows(handler);
				mysql_free_result(result);
				return rows;
			}
			else error();
		}
		return false;
	}
}