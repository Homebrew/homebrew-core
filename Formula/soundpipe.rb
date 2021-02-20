class Soundpipe < Formula
  desc "Lightweight music DSP library"
  homepage "https://paulbatchelor.github.io/proj/soundpipe.html"
  url "https://github.com/PaulBatchelor/soundpipe/archive/v1.7.0.tar.gz"
  sha256 "2d6f6b155ad93d12f59ae30e2b0f95dceed27e0723147991da6defc6d65eadda"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:    "775700eaea684293798d3a52192c3b2a24eb2b4bfe9c95c639ff41f1d819bf93"
    sha256 cellar: :any_skip_relocation, mojave:      "b47b5666b487eafcbd58637c541fccdd671abc89036fe3401aafd79ea4f04493"
    sha256 cellar: :any_skip_relocation, high_sierra: "e10ee9a2f4f97fc9c0ee91f9da5b5965ca04a147119e10237efb2eea1e162dc5"
    sha256 cellar: :any_skip_relocation, sierra:      "3975e1208784b80d78d9ad19b83836d1efe7b33d7e0e08d36c630863ee7a1a19"
  end

  disable! date: "2020-11-26", because: :repo_removed

  depends_on "libsndfile"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "examples", "test"
  end

  test do
    system ENV.cc, "#{pkgshare}/examples/ex_osc.c", "-o", "test", "-L#{lib}",
                   "-L#{Formula["libsndfile"].lib}", "-lsndfile", "-lsoundpipe"
    system "./test"
    assert_predicate testpath/"test.wav", :exist?
  end
end
