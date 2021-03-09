class Trace2html < Formula
  desc "Utility from Google Trace Viewer to convert JSON traces to HTML"
  homepage "https://github.com/google/trace-viewer"
  url "https://github.com/google/trace-viewer/archive/2015-07-07.tar.gz"
  version "2015-07-07"
  sha256 "6125826d07869fbd634ef898a45df3cabf45e6bcf951f2c63e49f87ce6a0442a"
  license "BSD-3-Clause"
  revision 1

  bottle :unneeded

  # https://github.com/google/trace-viewer/commit/5f708803
  deprecate! date: "2015-09-03", because: "has moved upstream repositories"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"tracing/trace2html"
  end

  test do
    touch "test.json"
    system "#{bin}/trace2html", "test.json"
    assert_predicate testpath/"test.html", :exist?
  end
end
