class Trace2html < Formula
  desc "Utility from Google Trace Viewer to convert JSON traces to HTML"
  homepage "https://github.com/catapult-project/catapult"
  url "https://github.com/catapult-project/catapult/archive/328391fbc1e3f931caf93d1e3f50d1643e624560.tar.gz"
  version "2016-09-08"
  sha256 "4439ba9037cd1328c7dcc4723537e02dfd99efad36363e025e06ab42c0b99c71"

  bottle :unneeded

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"tracing/bin/trace2html"
  end

  test do
    touch "test.json"
    system "#{bin}/trace2html", "test.json"
    assert File.exist?("test.html")
  end
end
