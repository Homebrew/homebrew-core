class Statica < Formula
  desc "Static Analysis meta toool"
  homepage "https://github.com/simpsonjulian/statica"
  url "https://github.com/simpsonjulian/statica/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "b39333008e3c776260d5a0ae8adf76fe4f06c97dfef02367c8c2d2a69ad73ad9"
  license "MIT"
  depends_on "checkov"
  depends_on "dependency-check"
  depends_on "lizard-analyzer"
  depends_on "pmd"
  depends_on "semgrep"
  depends_on "trivy"

  def install
    bin.install "statica"
    libexec.install "tools.d"
    lib.install %w[html_report.rb 2sarif.rb template.erb]
  end

  test do
    system "#{bin}/statica", "/tmp"
  end
end
