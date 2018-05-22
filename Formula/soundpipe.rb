class Soundpipe < Formula
  desc "Lightweight music DSP library"
  homepage "https://paulbatchelor.github.io/proj/soundpipe.html"
  url "https://github.com/PaulBatchelor/soundpipe/archive/v1.7.0.tar.gz"
  sha256 "2d6f6b155ad93d12f59ae30e2b0f95dceed27e0723147991da6defc6d65eadda"
  depends_on "libsndfile"

  def install
    system "make"
    system "make", "-C", "test"
    cp_r "test", prefix
    cp_r "examples", prefix
    system "make", "install", "PREFIX="+prefix
  end

  test do
    # TODO
    # While this command does test the library, it does so by printing out ok or
    # not ok for various tests. A more thorough test would check to make sure
    # that everything is ok before returning success.
    system "cd #{prefix}/test;#{prefix}/test/run.bin"
  end
end
