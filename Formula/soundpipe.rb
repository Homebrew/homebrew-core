class Soundpipe < Formula
  desc "Lightweight music DSP library"
  homepage "https://paulbatchelor.github.io/proj/soundpipe.html"
  url "https://github.com/PaulBatchelor/soundpipe/archive/v1.7.0.tar.gz"
  sha256 "2d6f6b155ad93d12f59ae30e2b0f95dceed27e0723147991da6defc6d65eadda"

  depends_on "libsndfile"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "test"
    pkgshare.install "examples"
  end

  test do
    system ENV.cc, "#{pkgshare}/examples/ex_osc.c", "-o", "test", "-L#{lib}",
                   "-L#{lib}", "-lsndfile", "-lsoundpipe"
    system "./test"
    assert_predicate testpath/"test.wav", :exist?
  end
end
