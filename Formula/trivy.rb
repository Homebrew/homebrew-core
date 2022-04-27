class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.27.1.tar.gz"
  sha256 "68efac954a31d33c438c5604fa1269aba164f275c7580260f3c8c033a3be2ac7"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f60a1060ba6c103a6a237280109e960162cb229f88b551f52770ee15e0a6c26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0e4085ac4d4a975b5ab2c314773ad47929787bad0f9535163c8c2362506e883"
    sha256 cellar: :any_skip_relocation, monterey:       "f168c35bef3decb26f010b54a993d1b6a76399f86c7b0c2119c6ef29cc34fedc"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8def73c7f9a680aab9e85a7a438379cfd0411fd3921c4d1a1e8d4d7c55b1782"
    sha256 cellar: :any_skip_relocation, catalina:       "4432a53efd17b75848be85e5d3c8155b1828a8a012025e15bf09eaa7fd7edf39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "819e4181fbd63522afc51b0b2e115079f6fbeab7e1a04bb3a0279ec66c331432"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
