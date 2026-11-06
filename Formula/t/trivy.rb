class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.76.2.tar.gz"
  sha256 "ea2670e94696508b12687e1f8ac35a6fe529893e351b7e38362c4a385ff2db9a"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "12935aaaae4cd947954312b358e6b3c787246fbeb6f8d56ef342e4f10df44ad2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "976d8d64e7bb0e9a8083545c12e3faa7c2c742148c0d8125f02d85e005cb7e1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e71be7a22ada103cd621248d7c4f6bfb43fe872f9993f9dd133ae8575e48c82"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4f44ce3ace0c5d87fc69d4a2c9ddbdda67da81147b0fca66655c51526ee0188d"
    sha256 cellar: :any,                 x86_64_linux:      "4f2fe3c062129231c4296835dda7c12f7b4eaa4ae94184bbcdbb6300fc6b05c1"
  end

  depends_on "go" => :build

  # `test do` block downloads a container image and the vulnerability DB
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[-X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}]
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
