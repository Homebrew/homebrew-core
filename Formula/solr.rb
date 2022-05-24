class Solr < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https://solr.apache.org/"
  url "https://dlcdn.apache.org/lucene/solr/8.11.1/solr-8.11.1.tgz"
  mirror "https://archive.apache.org/dist/lucene/solr/8.11.1/solr-8.11.1.tgz"
  sha256 "9ec540cbd8e45f3d15a6b615a22939f5e6242ca81099951a47d3c082c79866a9"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6e04a40c5e79ab36c410cae43a72c57895e3fa6f82a33eb2efe1d6cfdd632a7c"
  end

  depends_on "openjdk"

  # https://github.com/apache/solr/pull/250, remove with next release
  patch :p2, :DATA

  def install
    pkgshare.install "bin/solr.in.sh"
    (var/"lib/solr").install "server/solr/README.txt", "server/solr/solr.xml", "server/solr/zoo.cfg"
    prefix.install %w[contrib dist server]
    libexec.install "bin"
    bin.install [libexec/"bin/solr", libexec/"bin/post", libexec/"bin/oom_solr.sh"]

    env = Language::Java.overridable_java_home_env
    env["SOLR_HOME"] = "${SOLR_HOME:-#{var/"lib/solr"}}"
    env["SOLR_LOGS_DIR"] = "${SOLR_LOGS_DIR:-#{var/"log/solr"}}"
    env["SOLR_PID_DIR"] = "${SOLR_PID_DIR:-#{var/"run/solr"}}"
    bin.env_script_all_files libexec, env
    (libexec/"bin").rmtree

    inreplace libexec/"solr", "/usr/local/share/solr", pkgshare
  end

  def post_install
    (var/"run/solr").mkpath
    (var/"log/solr").mkpath
  end

  service do
    run [opt_bin/"solr", "start", "-f", "-s", HOMEBREW_PREFIX/"var/lib/solr"]
    working_dir HOMEBREW_PREFIX
  end

  test do
    ENV["SOLR_PID_DIR"] = testpath
    port = free_port

    # Info detects no Solr node => exit code 3
    shell_output(bin/"solr -i", 3)
    # Start a Solr node => exit code 0
    shell_output(bin/"solr start -p #{port} -Djava.io.tmpdir=/tmp")
    # Info detects a Solr node => exit code 0
    shell_output(bin/"solr -i")
    # Impossible to start a second Solr node on the same port => exit code 1
    shell_output(bin/"solr start -p #{port}", 1)
    # Stop a Solr node => exit code 0
    # Exit code is 1 in a docker container, see https://github.com/apache/solr/pull/250
    shell_output(bin/"solr stop -p #{port}", OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"] ? 1 : 0)
    # No Solr node left to stop => exit code 1
    shell_output(bin/"solr stop -p #{port}", 1)
  end
end

__END__
diff --git a/solr/bin/solr b/solr/bin/solr
index 3a6f0e493e4..cfc6f3032c8 100755
--- a/solr/bin/solr
+++ b/solr/bin/solr
@@ -699,7 +699,7 @@ function solr_pid_by_port() {
   THE_PORT="$1"
   if [ -e "$SOLR_PID_DIR/solr-$THE_PORT.pid" ]; then
     PID=`cat "$SOLR_PID_DIR/solr-$THE_PORT.pid"`
-    CHECK_PID=`ps auxww | awk '{print $2}' | grep -w $PID | sort -r | tr -d ' '`
+    CHECK_PID=`ps -o pid='' $PID | tr -d ' '`
     if [ "$CHECK_PID" != "" ]; then
       local solrPID=$PID
     fi
@@ -843,14 +843,17 @@ function stop_solr() {
   STOP_KEY="$3"
   SOLR_PID="$4"
 
-  if [ "$SOLR_PID" != "" ]; then
+  if [ -n "$SOLR_PID"  ]; then
     echo -e "Sending stop command to Solr running on port $SOLR_PORT ... waiting up to $SOLR_STOP_WAIT seconds to allow Jetty process $SOLR_PID to stop gracefully."
     "$JAVA" $SOLR_SSL_OPTS $AUTHC_OPTS -jar "$DIR/start.jar" "STOP.PORT=$THIS_STOP_PORT" "STOP.KEY=$STOP_KEY" --stop || true
       (loops=0
       while true
       do
-        CHECK_PID=`ps auxww | awk '{print $2}' | grep -w $SOLR_PID | sort -r | tr -d ' '`
-        if [ "$CHECK_PID" != "" ]; then
+        # Check if a process is running with the specified PID.
+        # -o stat will output the STAT, where Z indicates a zombie
+        # stat='' removes the header (--no-headers isn't supported on all platforms)
+        STAT=`ps -o stat='' $SOLR_PID | tr -d ' '`
+        if [[ "$STAT" != "" && "$STAT" != "Z" ]]; then
           slept=$((loops * 2))
           if [ $slept -lt $SOLR_STOP_WAIT ]; then
             sleep 2
@@ -869,8 +872,8 @@ function stop_solr() {
     exit 0
   fi
 
-  CHECK_PID=`ps auxww | awk '{print $2}' | grep -w $SOLR_PID | sort -r | tr -d ' '`
-  if [ "$CHECK_PID" != "" ]; then
+  STAT=`ps -o stat='' $SOLR_PID | tr -d ' '`
+  if [[ "$STAT" != "" && "$STAT" != "Z" ]]; then
     if [ "$JSTACK" != "" ]; then
       echo -e "Solr process $SOLR_PID is still running; jstacking it now."
       $JSTACK $SOLR_PID
@@ -885,8 +888,13 @@ function stop_solr() {
     sleep 10
   fi
 
-  CHECK_PID=`ps auxww | awk '{print $2}' | grep -w $SOLR_PID | sort -r | tr -d ' '`
-  if [ "$CHECK_PID" != "" ]; then
+  STAT=`ps -o stat='' $SOLR_PID | tr -d ' '`
+  if [ "$STAT" == "Z" ]; then
+    # This can happen if, for example, you are running Solr inside a docker container with multiple processes
+    # rather than running it is as the only service. The --init flag on docker avoids that particular problem.
+    echo -e "Solr process $SOLR_PID has terminated abnormally. Solr has exited but a zombie process entry remains."
+    exit 1
+  elif [ "$STAT" != "" ]; then
     echo "ERROR: Failed to kill previous Solr Java process $SOLR_PID ... script fails."
     exit 1
   fi
@@ -1871,7 +1879,7 @@ if [[ "$SCRIPT_CMD" == "stop" && -z "$SOLR_PORT" ]]; then
     if [ $numSolrs -eq 1 ]; then
       # only do this if there is only 1 node running, otherwise they must provide the -p or -all
       PID="$(cat "$(find "$SOLR_PID_DIR" -name "solr-*.pid" -type f)")"
-      CHECK_PID=`ps auxww | awk '{print $2}' | grep -w $PID | sort -r | tr -d ' '`
+      CHECK_PID=`ps -o pid='' $PID | tr -d ' '`
       if [ "$CHECK_PID" != "" ]; then
         port=`jetty_port "$CHECK_PID"`
         if [ "$port" != "" ]; then
