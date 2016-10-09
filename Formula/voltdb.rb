class Voltdb < Formula
  desc "Horizontally-scalable, in-memory SQL RDBMS"
  homepage "https://github.com/VoltDB/voltdb"
  url "https://github.com/VoltDB/voltdb/archive/voltdb-6.6.tar.gz"
  sha256 "300d06c8f5a1cc4a3537f216ea105d5ccc8987b10bad2c676a40543c8903d72e"
  head "https://github.com/VoltDB/voltdb.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e1e07f1c931d65d5b78d0257e96105e07c7c933044a277f164be733d459ea1f" => :sierra
    sha256 "abc39a5926dc83b8516c8697beeef5d722049bf487d28db60f4a095cc5299329" => :el_capitan
    sha256 "300a47847d49c7e2d2dfb37c860cd4e60b1074d43dab450433a8c49879c9c46b" => :yosemite
    sha256 "de7b5adf80d177bde762b71d1044a901b2b68b0b22ec328f73137b99fc885248" => :mavericks
  end

  depends_on :ant => :build
  depends_on "cmake" => :build

  patch :DATA

  def install
    system "ant"

    inreplace Dir["bin/*"] - ["bin/voltadmin", "bin/voltdb", "bin/rabbitmqloader", "bin/voltdeploy", "bin/voltenv"],
      %r{VOLTDB_LIB=\$VOLTDB_HOME\/lib}, "VOLTDB_LIB=$VOLTDB_HOME/lib/voltdb"

    (lib/"voltdb").install Dir["lib/*"]
    lib.install_symlink lib/"voltdb/python"
    prefix.install "bin", "tools", "voltdb", "version.txt", "doc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/voltdb --version")
  end
end

__END__
--- voltdb-voltdb-6.6/bin/voltenv.orig	2016-10-09 11:08:34.000000000 +0300
+++ voltdb-voltdb-6.6/bin/voltenv	2016-10-09 11:09:20.000000000 +0300
@@ -28,7 +28,7 @@
 if [ -d "$VOLTDB_BIN/../lib/voltdb" ]; then
     VOLTDB_BASE=$(dirname "$VOLTDB_BIN")
     VOLTDB_LIB="$VOLTDB_BASE/lib/voltdb"
-    VOLTDB_VOLTDB="$VOLTDB_LIB"
+    VOLTDB_VOLTDB="$VOLTDB_BASE/voltdb"
 # distribution layout has libraries in separate lib and voltdb directories
 else
     VOLTDB_BASE=$(dirname "$VOLTDB_BIN")
@@ -115,7 +115,7 @@
 # if this script is run directly:
 # Run the target passed as the first arg on the command line
 # If no first arg, do nothing
-if [ "${0}" = "$SOURCE" ]; then
+if [ "${0}" = "${BASH_SOURCE[0]}" ]; then
     if [ $# -gt 1 ]; then
         envhelp
         exit 0
