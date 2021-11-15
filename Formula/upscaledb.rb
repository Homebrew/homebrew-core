class Upscaledb < Formula
  desc "Database for embedded devices"
  homepage "https://upscaledb.com/"
  license "Apache-2.0"
  head "https://github.com/cruppstahl/upscaledb.git", branch: "master"

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
    sha256 cellar: :any, big_sur:     "a0fd351d906363c321b21832fe00324df1c1cdd7aa1bb44c64075b1710aca916"
    sha256 cellar: :any, catalina:    "b507da019b3c2491594d7ad127e980d098f80f78f044e00b4f07a3f3cdd9b795"
    sha256 cellar: :any, mojave:      "85e1468d77fa72b7cfc4e039877018648b79e8eb7006e63263fbdd44978f043a"
    sha256 cellar: :any, high_sierra: "9e15c86df38e916f08ba95254fe675e60b250b7e8e72e9dd9e07a6ff226dd092"
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
