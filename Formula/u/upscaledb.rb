class Upscaledb < Formula
  desc "Database for embedded devices"
  homepage "https://upscaledb.com/"
  license "Apache-2.0"
  revision 5
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

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f9e07f206aa8c7656e752da77826815d0bc704c2f71beaed6341817b60cb9ba5"
    sha256 cellar: :any,                 arm64_ventura:  "31263250b809be124c24d249704e8a84de26c46c12b1f9e4a7abea51dbd79c4f"
    sha256 cellar: :any,                 arm64_monterey: "c6cbe6b8adad2e84227bc980e6c68c4ed4334a4bdfa95a19b2a396adb01b87a8"
    sha256 cellar: :any,                 arm64_big_sur:  "60ead2f03c0516d85867b3bf1d5070fcde864c30826e5143bc73bc82dceefe52"
    sha256 cellar: :any,                 sonoma:         "69a4883083e54f64c9e7f798eeebf7e449c18ca8a727896e5e77f06caf61ada7"
    sha256 cellar: :any,                 ventura:        "6310bae4f6d2a68eada0d688b15ccef4aaba1a1552549bc111dd47bd01ecdbec"
    sha256 cellar: :any,                 monterey:       "5972bc432022b76c16388c7accd2290506193e9d375a505f4a4bff3796982425"
    sha256 cellar: :any,                 big_sur:        "aaec25a0ebacba42a481712faf1051440c3c457d1a67d1672f495cda961ed93c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98b54b8cb472d3c1810899301aecbe116c1c0dd5120d476ace114f12ee725d84"
  end

  deprecate! date: "2023-10-19", because: :does_not_build

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "gnutls"
  depends_on "openjdk"
  depends_on "openssl@3"

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
