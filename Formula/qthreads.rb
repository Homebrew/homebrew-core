class Qthreads < Formula
  desc "Lightweight locality-aware user-level threading runtime"
  homepage "https://github.com/Qthreads/qthreads"
  url "https://github.com/Qthreads/qthreads/releases/download/1.17/qthread-1.17.tar.gz"
  sha256 "619a89c29c9271eac119f8bdad0964cefdebe7f9276330e81e3a527e83d9e359"
  license "BSD-3-Clause"
  head "https://github.com/Qthreads/qthreads.git", branch: "main"

  bottle do
    sha256 cellar: :any, monterey: "c3e5ccea2cd274bcfd0a885b0a6144162e7a91c4219a73a8f88dc279d848ca55"
    sha256 cellar: :any, big_sur:  "e0f9e60cb18bafc88477533ca65f3c78a821188a3cd2bb077e3a90ad886c2c3d"
    sha256 cellar: :any, catalina: "0ee47db33538dfea98f384927d9b5e9c9d43b2c7391f6308fb47c740c62bec8c"
    sha256 cellar: :any, mojave:   "0eb14aec995c438dab677dc3084bf772a5ff083812a5d3a0eac988ed08496a42"
  end

  # https://github.com/Qthreads/qthreads/issues/83
  depends_on arch: :x86_64

  def install
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
    system ENV.cc, "-o", "hello", "-I#{include}", "-L#{lib}", "-lqthread", pkgshare/"examples/hello_world.c"
    assert_equal "Hello, world!", shell_output("./hello").chomp
  end
end
