class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.32.1.tar.gz"
  sha256 "9a51965dd430fb3d23aa72aff9dcf8538704aaadbf4c3d4acb4f017c1f8fea01"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1c5caf69d4853b3549fbd478a4d84d362d014b21a2a3900150be38d5ef3f6e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de0a478d798d5dd60e23aa159ccfd35ea91bac7479884bdf8c03cc889507421b"
    sha256 cellar: :any_skip_relocation, monterey:       "cc2334888c9fa99469c762f5760af78bdae81c7228431bfc84557b2c805baebe"
    sha256 cellar: :any_skip_relocation, big_sur:        "70849a8bd1957c68e07f402a44cad1f2f99a8d5f2eb72eca5390f93c5613c8f2"
    sha256 cellar: :any_skip_relocation, catalina:       "1c9da3d6fb1dfaaa722d1e84fccb866af6e8e284ac2d2db075e40f96b464b2a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9731303ea153e014a469a9af5d02d9f4f8eedbaeffeef46c5a0ccee1513085bd"
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
