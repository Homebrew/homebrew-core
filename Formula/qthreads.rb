class Qthreads < Formula
  desc "Lightweight locality-aware user-level threading runtime"
  homepage "https://github.com/Qthreads/qthreads"
  url "https://github.com/Qthreads/qthreads/releases/download/1.16/qthread-1.16.tar.bz2"
  sha256 "923d58f3ecf7d838a18c3616948ea32ddace7196c6805518d052c51a27219970"
  license "BSD-3-Clause"
  head "https://github.com/Qthreads/qthreads.git"

  bottle do
    sha256 cellar: :any, big_sur:  "1b38fc8670cd871f3bcbc3d0f7af6b7a481954d178265fa4000933ea4a081393"
    sha256 cellar: :any, catalina: "4697fa448afd2b9cf71b618e9978b91399882b10265c04a9606eadb90d4ab9e4"
    sha256 cellar: :any, mojave:   "0e4094e7737f755ebb39cbea97a3591927ecc8ded4f8654efb6c68dcc73a0928"
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
