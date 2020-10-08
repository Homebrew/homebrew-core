class Upscaledb < Formula
  desc "Database for embedded devices"
  homepage "https://upscaledb.com/"
  license "Apache-2.0"
  head "https://github.com/cruppstahl/upscaledb.git"

  stable do
    url "https://github.com/cruppstahl/upscaledb.git",
      tag:      "release-2.2.1",
      revision: "60d39fc19888fbc5d8b713d30373095a41bf9ced"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/31fa2b66ae637e8f1dc2864af869baa34604f8fe/upscaledb/2.2.1.diff"
      sha256 "fc99845f15e87c8ba30598cfdd15f0f010efa45421462548ee56c8ae26a12ee5"
    end
  end

  livecheck do
    url "http://files.upscaledb.com/dl/"
    regex(/href=.*?upscaledb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "16803511bcf21348ddd6c71d76367fef5961188d2b0f467a3ec05b044db5b3f7" => :catalina
    sha256 "b07269e80731ac5700a84b05f1725a49d59e40191bbab4661750b204f14ba9b3" => :mojave
    sha256 "003ac2a786a136acf66f8de4a25a0d72950c21dbb4e4b70afad486bba01319d7" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "gnutls"
  depends_on "openjdk"
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    # Avoid references to Homebrew shims
    ENV["SED"] = "sed"

    system "./bootstrap.sh"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-remote", # upscaledb is not compatible with latest protobuf
                          "--prefix=#{prefix}",
                          "JDK=#{Formula["openjdk"].opt_prefix}"
    system "make", "install"

    pkgshare.install "samples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lupscaledb",
           pkgshare/"samples/db1.c", "-o", "test"
    system "./test"
  end
end
