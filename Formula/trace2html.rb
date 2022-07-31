class Trace2html < Formula
  desc "Utility from Google Trace Viewer to convert JSON traces to HTML"
  homepage "https://github.com/google/trace-viewer"
  url "https://github.com/google/trace-viewer/archive/2015-07-07.tar.gz"
  version "2015-07-07"
  sha256 "6125826d07869fbd634ef898a45df3cabf45e6bcf951f2c63e49f87ce6a0442a"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1cfa6d0038b3faff1fbcec844f6cd955a332ab27b6cb88e7fd915954390affe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32764a563ad476d574353f8c911c341d8831a6154bda4c068f6c7524724e640d"
    sha256 cellar: :any_skip_relocation, monterey:       "491b4f9d7b8b4be6cb1f3ebde16ff3ddd7dad449e977518cde47b10adae15b58"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbe734ca273dc6851bca4b52646389d9593608f92f777abed4a7df97e3314a67"
    sha256 cellar: :any_skip_relocation, catalina:       "cbe734ca273dc6851bca4b52646389d9593608f92f777abed4a7df97e3314a67"
    sha256 cellar: :any_skip_relocation, mojave:         "cbe734ca273dc6851bca4b52646389d9593608f92f777abed4a7df97e3314a67"
  end

  # https://github.com/google/trace-viewer/commit/5f708803
  disable! date: "2022-07-31", because: "has moved upstream repositories"

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
