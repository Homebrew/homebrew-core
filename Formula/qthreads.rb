class Qthreads < Formula
  desc "Lightweight locality-aware user-level threading runtime"
  homepage "https://github.com/Qthreads/qthreads"
  url "https://github.com/Qthreads/qthreads/archive/refs/tags/1.18.tar.gz"
  sha256 "c2d1ba85533dc980ff61e422c9b7531417e8884c3a1a701d59229c0e6956594c"
  license "BSD-3-Clause"
  head "https://github.com/Qthreads/qthreads.git", branch: "main"

  bottle do
    sha256 cellar: :any, monterey: "c3e5ccea2cd274bcfd0a885b0a6144162e7a91c4219a73a8f88dc279d848ca55"
    sha256 cellar: :any, big_sur:  "e0f9e60cb18bafc88477533ca65f3c78a821188a3cd2bb077e3a90ad886c2c3d"
    sha256 cellar: :any, catalina: "0ee47db33538dfea98f384927d9b5e9c9d43b2c7391f6308fb47c740c62bec8c"
    sha256 cellar: :any, mojave:   "0eb14aec995c438dab677dc3084bf772a5ff083812a5d3a0eac988ed08496a42"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make"
    system "make", "install"
    pkgshare.install "userguide/examples"
    doc.install "userguide"
  end

  test do
    system ENV.cc, pkgshare/"examples/hello_world.c", "-o", "hello", "-I#{include}", "-L#{lib}", "-lqthread"
    assert_equal "Hello, world!", shell_output("./hello").chomp
  end
end
