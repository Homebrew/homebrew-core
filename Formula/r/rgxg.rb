class Rgxg < Formula
  desc "C library and command-line tool to generate (extended) regular expressions"
  homepage "https://rgxg.github.io"
  url "https://github.com/rgxg/rgxg/releases/download/v0.1.2/rgxg-0.1.2.tar.gz"
  sha256 "554741f95dcc320459875c248e2cc347b99f809d9555c957d763d3d844e917c6"
  license "Zlib"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "f0cc6fe2faf8619f981684d24e751f270a9bd1b5d04282165135296e73dbe8d0"
    sha256 cellar: :any,                 arm64_sequoia:  "80c6d906b67ef65832f1724146eef85c50e01d73f3808c87c7b4dd1eadc39102"
    sha256 cellar: :any,                 arm64_sonoma:   "6b1d2f700c3ca6fc03930409bb4ec68cbdbcbb2931facef03d2422369c29f81a"
    sha256 cellar: :any,                 arm64_ventura:  "56fc8fea2ebbbe0a03cddb55f18d6a744b7ab028980276b8e17a2fdada7f6cce"
    sha256 cellar: :any,                 arm64_monterey: "7c78f7917c24d61418d48dbdb2b61eea9f098cfdc999532542044372fbea04af"
    sha256 cellar: :any,                 arm64_big_sur:  "42b3f11c2a0fe78d84df3ae4ef3bcf9d3dd4cb04a5f8ac9a2c2196c7ef7b904b"
    sha256 cellar: :any,                 sonoma:         "4d80dd551bd529ec03c15e5be306ce958def4720a51598e335d5ed5e5a2da8db"
    sha256 cellar: :any,                 ventura:        "ed2bfec2c314aad06476ce78a33f9c6cc4d1c1f18e254dba53f71bfcbcf66596"
    sha256 cellar: :any,                 monterey:       "5c575a40c8ac2b3b133bf004af5562380d452d279f0c7d1819a394c686503089"
    sha256 cellar: :any,                 big_sur:        "37ed8cafce126a6ab77b1e367dbe2a72a68c6556569694366e16844b18071dce"
    sha256 cellar: :any,                 catalina:       "4a07550d93bedfa3b2ac3cb77a8484951321697ca9384d2c2a0301ea261aa954"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "28194f32ee9974ae3367a4cc1fe604bd91534171a52a7d7bd0401379591d078f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2295a106e3ff336aef5f2fccd382d123351ca6e29f863bbf62afaa90072bb16"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"rgxg", "range", "1", "10"
  end
end
