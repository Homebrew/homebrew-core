class Upscaledb < Formula
  desc "Database for embedded devices"
  homepage "https://upscaledb.com/"
  license "Apache-2.0"
  revision 2
  head "https://github.com/cruppstahl/upscaledb.git", branch: "master"

  stable do
    url "https://github.com/cruppstahl/upscaledb.git",
        tag:      "release-2.2.1",
        revision: "60d39fc19888fbc5d8b713d30373095a41bf9ced"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/31fa2b66ae637e8f1dc2864af869baa34604f8fe/upscaledb/2.2.1.diff"
      sha256 "fc99845f15e87c8ba30598cfdd15f0f010efa45421462548ee56c8ae26a12ee5"
    end

    # Fix compilation on non-SIMD platforms. Remove in the next release.
    patch do
      url "https://github.com/cruppstahl/upscaledb/commit/80d01b843719d5ca4c6fdfcf474fa0d66cf877e6.patch?full_index=1"
      sha256 "3ec96bfcc877368befdffab8ecf2ad2bd7157c135a1f67551b95788d25bee849"
    end

    # Fix compilation on GCC 11. Remove in the next release.
    patch do
      url "https://github.com/cruppstahl/upscaledb/commit/b613bfcb86eaddaa04ec969716560949b63ebd98.patch?full_index=1"
      sha256 "cc909bf92248f1eeff5ed414bcac8788ed1e479fdcfeec4effdd36b1092dd0bd"
    end
  end

  livecheck do
    url "http://files.upscaledb.com/dl/"
    regex(/href=.*?upscaledb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "681c6480b867cfabe84dc86f642ff8190a09db19cbba45e2ab825c08bb22e8c5"
    sha256 cellar: :any,                 arm64_big_sur:  "52c35ae632361c43f0134e4601f447d8f0ce5849e054a697c56a821380515ef1"
    sha256 cellar: :any,                 monterey:       "eb56657cf69888dfe9a60d62f021470f59b402a846b1c08f623d672c55032663"
    sha256 cellar: :any,                 big_sur:        "92a278053f801938558c40b6ab2284125e1da0c4815caa1dc75b6bdf8cd83ebf"
    sha256 cellar: :any,                 catalina:       "b902d877822ecdd047b3286a45ccd28a732655d1f672ec7ba104181307c2d7af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c693331be7046fb3f52e6a046aa1279943c086731a164192740b2cee07ec2864"
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

    simd_arg = Hardware::CPU.intel? ? [] : ["--disable-simd"]
    system "./configure", *std_configure_args,
                          *simd_arg,
                          "--disable-remote", # upscaledb is not compatible with latest protobuf
                          "JDK=#{Formula["openjdk"].opt_prefix}"
    system "make", "install"

    pkgshare.install "samples"

    # Fix shim reference on Linux
    inreplace pkgshare/"samples/Makefile", Superenv.shims_path, "" unless OS.mac?
  end

  test do
    system ENV.cc, pkgshare/"samples/db1.c", "-I#{include}",
           "-L#{lib}", "-lupscaledb", "-o", "test"
    system "./test"
  end
end
