class Trace2html < Formula
  desc "Trace2Html"
  homepage "https://github.com/catapult-project/catapult/tree/master/tracing"
  url "https://github.com/catapult-project/catapult/archive/9dae3963cdd72211f17a2c976dd077d1125cdde7.tar.gz"
  sha256 "b0c0ecc94d63395c69393f79d5b5dd25b3871cf3849b1e7566a57fb7c571cb74"

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
