class Upscaledb < Formula
  desc "Database for embedded devices"
  homepage "https://upscaledb.com/"
  license "Apache-2.0"
  revision 3
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
    url "https://files.upscaledb.com/dl/"
    regex(/href=.*?upscaledb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3e53df8a01216c9fb312eea599fa6a4ce5aa996476b3618157c613baa7631973"
    sha256 cellar: :any,                 arm64_monterey: "4165747c590e3fa385edb3ca82572e61c6d7d46fab5ab0653506113af584ad54"
    sha256 cellar: :any,                 arm64_big_sur:  "4d2ffbcb757f65413634d50556cb8be81871c3915cb5b173d60b146428843504"
    sha256 cellar: :any,                 ventura:        "b77dd8e5fccacf9fb9f3e89fc62005afeea0bcca6d0682ad22ed412d7222068a"
    sha256 cellar: :any,                 monterey:       "fe6720fa4fef28905e48926764bd350eb9cb7ef86a8cf3ebb17f5fd320f50a15"
    sha256 cellar: :any,                 big_sur:        "23a345451fc0f2ba05ad1b84e3eaa58efb8deb84096d084c0550c0751e7bfd03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9388aed680e2927f5953ae803bffd0bc0bf6a239efbed1e9ea06ccb3144d0653"
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
