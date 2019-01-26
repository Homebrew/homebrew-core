class Trace2html < Formula
  desc "Utility from Google Trace Viewer to convert JSON traces to HTML"
  homepage "https://github.com/catapult-project/catapult/tree/master/tracing"
  url "https://github.com/catapult-project/catapult/archive/93d499d2f97f3c298a77dff1a55befdf7e97d2a4.tar.gz"
  version "2019-01-26"
  sha256 "1779b759d08c5b75ac9a59b3065ac5aa5531e33337b418d1a124bda3d06d173f"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"tracing/bin/trace2html"
  end

  test do
    touch "test.json"
    system "#{bin}/trace2html", "test.json"
    assert_predicate testpath/"test.html", :exist?
  end
end
