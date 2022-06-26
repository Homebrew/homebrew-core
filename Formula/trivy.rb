class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.29.2.tar.gz"
  sha256 "df82e986e05032f9b08bc9b35eea0926f312ed7c839c6eb9ea6553c482e4f988"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37e8ea97d0e092bd44635c6f7ebe46bed8e265557a8e76c766b89524d70d18be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a3324d6dd1d586695b27a87c1dab65efaef20dc51103da34a4c353aa98a98bd"
    sha256 cellar: :any_skip_relocation, monterey:       "2941d285bd1649643687dd276cc3f06dfef23b444166b3db739236a5e9271e8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8bd8fada8439d85d793c5d2eeeca0356090ff8bced590faac88c0bcdd241ac9"
    sha256 cellar: :any_skip_relocation, catalina:       "7df5162e4479052ff519f5ba632f7836c98536139439dfb406fd437a3842659d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49ee3a643b1f5bf4bd404d00de15d8a15075525b135058ead0097f0ae83b2b2f"
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
