class Wiredtiger < Formula
  desc "High performance NoSQL extensible platform for data management"
  homepage "https://source.wiredtiger.com/"
  url "https://github.com/wiredtiger/wiredtiger/releases/download/10.0.0/wiredtiger-10.0.0.tar.bz2"
  sha256 "4830107ac744c0459ef99697652aa3e655c2122005a469a49d221e692fb834a5"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4b72a7ac0c4f99e3fa6cdd8395f03bf0c819ccbcd90e9e4ce373de6e016180f4"
    sha256 cellar: :any,                 arm64_big_sur:  "2e2b170afa925805d7f94e127dc6c66f7ae5d042a37860e736e9c6cbf1696acb"
    sha256 cellar: :any,                 monterey:       "2d693bed27b7602f8645f861bd063f98ef9e9653294e238550a57c4fbb762924"
    sha256 cellar: :any,                 big_sur:        "73dec56cf3779376bb1e111c6d96900bfd73e5df072dfce752defaf06d98b167"
    sha256 cellar: :any,                 catalina:       "16d0323167834b745163edf87b88693a7b49ace3f901042c0d78fbfbe5afa8a8"
    sha256 cellar: :any,                 mojave:         "0c2bbb142e29427648f66455b69028d1650b3d420700d31e952a70e58cc361f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e89496c6a6af975b83b16006c84ef7c69d7df3b0e127e2f58a3b2ff6cfc860f"
  end

  depends_on "snappy"

  uses_from_macos "zlib"

  # Workaround to build on ARM with system type 'arm-apple-darwin*'
  # Remove in next release as build system is changing to CMake
  patch :DATA

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--with-builtins=snappy,zlib",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wt", "create", "table:test"
    system "#{bin}/wt", "drop", "table:test"
  end
end

__END__
--- a/configure
+++ b/configure
@@ -16317,7 +16317,7 @@ else
 fi

 case $host_cpu in #(
-  aarch64*) :
+  aarch64*|arm*) :
     wt_cv_arm64="yes" ;; #(
   *) :
     wt_cv_arm64="no" ;;
