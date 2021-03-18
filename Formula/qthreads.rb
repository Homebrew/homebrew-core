class Qthreads < Formula
  desc "Lightweight locality-aware user-level threading runtime"
  homepage "https://github.com/Qthreads/qthreads"
  url "https://github.com/Qthreads/qthreads/releases/download/1.16/qthread-1.16.tar.bz2"
  sha256 "923d58f3ecf7d838a18c3616948ea32ddace7196c6805518d052c51a27219970"
  license "BSD-3-Clause"
  head "https://github.com/Qthreads/qthreads.git"

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
