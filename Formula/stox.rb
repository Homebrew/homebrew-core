class Stox < Formula
  desc "A Swift command-line tool to view and export tickers from finviz.com stock screener."
  homepage "https://github.com/xbladesub/stox"
  url "https://github.com/xbladesub/stox/archive/1.0.1.tar.gz"
  sha256 "f037220a0b810775dad6e4df77f335aa9e96ed10b94784ae8d2821a69c628e3b"
  license "MIT"

  depends_on xcode: "12.4"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc", \
      "-cross-module-optimization", "--enable-test-discovery"
    mv ".build/release/stox", "stox"
    bin.install "stox"
  end

  test do
    system "stox", "help", "-n"
  end
end
