class Upscaledb < Formula
  desc "Database for embedded devices"
  homepage "https://upscaledb.com/"
  license "Apache-2.0"
  revision 4
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
    sha256 cellar: :any,                 arm64_ventura:  "4facbf55c8d3b3219086d4b55cb9cd73232a357661a774dbfbbe8efd8ef45701"
    sha256 cellar: :any,                 arm64_monterey: "34e184c0d5af342ba3e4d5a0624b0f38e1461dc5d620bac46725fe8e5f0cd92a"
    sha256 cellar: :any,                 arm64_big_sur:  "e580660670e526bc6d893614cb5eaf4afe4968b2951e8fcc13960c454e8e2854"
    sha256 cellar: :any,                 ventura:        "abf2fa403bacb77cf03041cc6d317342291e8a5b141efc264e6da602ce081f6f"
    sha256 cellar: :any,                 monterey:       "fae9bd3cd94fed44b2610f78c1071a112610dc130dd75da78eccc89bb798a1b5"
    sha256 cellar: :any,                 big_sur:        "8f39751ea366f4aa0adb741e4c6fa3017af5921701888b37231d7294215b3968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d3bfbdf22530a65027115e771a013f348cbc990f6a679877f0cceb4abdf5839"
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
