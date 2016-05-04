class Trace2html < Formula
  desc "Utility from Google Trace Viewer to convert JSON traces to HTML"
  homepage "https://github.com/catapult-project/catapult"
  url "https://github.com/ndfred/catapult/archive/9ee5e561160a0f62302b5fbe32c4d5454512b233.tar.gz"
  sha256 "e839d313be02ef1f4adf6351d49810561eda1094945649941ea7a0c065279cb9"
  version "2016-05-04"

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
