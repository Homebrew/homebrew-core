class Wiki < Formula
  desc "Fetch summaries from MediaWiki wikis, like Wikipedia"
  homepage "https://github.com/walle/wiki"
  url "https://github.com/walle/wiki/archive/v1.4.1.tar.gz"
  sha256 "529c6a58b3b5c5eb3faab07f2bf752155868b912e4f753e432d14040ff4f4262"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff424f6afbc0d2baab91cee289157d9c90623fa19b7d51574b75df455da76cd6" => :catalina
    sha256 "316687b381ca23ee0e81eb6e396d2c8c21a5eeaf05a9219ec56dd0024a8d9722" => :mojave
    sha256 "bd1b52730bbf5bc503d3fece003b069e248261616d9d02767ef019d87659bdd8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"wiki", "cmd/wiki/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wiki --version")

    assert_match "Read more: https://en.wikipedia.org/wiki/Go", shell_output("#{bin}/wiki golang")
  end
end
