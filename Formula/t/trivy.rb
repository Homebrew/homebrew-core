class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.68.2.tar.gz"
  sha256 "dd8efd719709d09b41c98cdb9090654f8ed326f07b05ba7a4ffca4de2745aea3"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cc408d86410d9be6f6d1d9aefb1cecc65775e6e906b6a9d8bbfb5c0e6b5a283"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fbff6cc920f5f32ff4b518ba9067b9039fa78396d8d560c13e1f87487445971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20df353825a598a73db8eb9fbe3e7d5f5e51bffd7f1e4af09c7d0de698d572c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e2fc0c1e8c300437806279553340a119491f44b6fc69577ddeb5d35b50444ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9296188e3d2819c960dcd97b7f3a36f6b8731fddffe9a1a8dd8604e4c4ee4481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c551a55ceeb43324fe23f6f3572366f7f347eaa2ab18e949b8ce42f5d3082220"
  end

  depends_on "go" => :build

  def install
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
    (pkgshare/"templates").install Dir["contrib/*.tpl"]

    generate_completions_from_executable(bin/"trivy", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
