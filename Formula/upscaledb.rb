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
    sha256 cellar: :any,                 monterey:     "693a8a0ad4e8298847d25bb2ef348a39249f3c05cc9ccf578e7b7db57db0c8c3"
    sha256 cellar: :any,                 big_sur:      "b6b0005cf98da8d3ecc3f762782d9129634023e53fd3303febf4e1bc145486d3"
    sha256 cellar: :any,                 catalina:     "5731bf62beee7d010c92d841d69b93620865a5c048e0a6b52cd60a1e906d46c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "17ba39ba89047d56cdab9a056cd541e2916447f8f3527bc22fae77354467d075"
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
