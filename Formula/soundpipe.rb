require 'digest'

class Soundpipe < Formula
  desc "Lightweight music DSP library"
  homepage "https://paulbatchelor.github.io/proj/soundpipe.html"
  url "https://github.com/PaulBatchelor/soundpipe/archive/v1.7.0.tar.gz"
  sha256 "2d6f6b155ad93d12f59ae30e2b0f95dceed27e0723147991da6defc6d65eadda"

  depends_on "libsndfile"

  def install
    system "make"
    mkdir_p pkgshare
    cp_r "test", pkgshare
    cp_r "examples", pkgshare
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system ENV.cc, "#{pkgshare}/examples/ex_osc.c", "-o#{testpath}/test",
          "-L#{lib}", "-L#{HOMEBREW_PREFIX}/lib", "-lsndfile", "-lsoundpipe"
    system "cd #{testpath};./test"
    hash = "07caba5db440b7442fbe8d40145e0dbc06ef52c0088380e581c6071a05c94bc6"
    assert_equal hash, Digest::SHA256.file("#{testpath}/test.wav").hexdigest
  end
end
