class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.37.0.tar.gz"
  sha256 "f1e64f0442a46abbf003e031baf118498bb31879353d0c513ac22924457b0899"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e4b119a241f095f85136a4ee12ff8842be2674de2b16ecabc1d77b4f7aba264"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bd69f814d2e99a5b08e4cf9fbaec5f18d8c4f2585ead124c59086297bae886e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9202883ddacbe67a5ab8758fa1e99cd2b0c471ab0214dcacf736b23a45b3a19"
    sha256 cellar: :any_skip_relocation, ventura:        "c38d2475a219165f6f09b06f8204837990663db11301191a620e802b4bd24be2"
    sha256 cellar: :any_skip_relocation, monterey:       "c8775e72ea0f3d1f206fe1ae1266cd1c4f55b9570a9301267b2bcd7e558f95e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdfd2ce444186f6afb2c990727e25d2eefdedc2f2ae780ab57ca027154bc2637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c090cfd8e4ef166bc7f16083d72960b7e731dfc03576a2152cfa1f960b88519"
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
