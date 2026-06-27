class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.71.2.tar.gz"
  sha256 "a4f4187644f6bdfba393c3c194b9ef8acc3891933c6faeeac8715a057db33785"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "965c1bdfb3a3925200038df442641e700a5beb6417fe7563426b3a06fa01ca23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41a8f928ec0c97577a23b346b19b8f228f3a595c94251efff464c39b8b4169a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "187c8d05f4412b827a471ee199624f64ce8679d9cd45f89810f8698270272006"
    sha256 cellar: :any_skip_relocation, sonoma:        "16b4751d07d001ad64a28a7b01e754b1b2777dcc78f2f3371e47eb2449a6f822"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff75f907b6f89cb430d0c56820432cf3fd754b3965b2acc5b9ed82af6a53aaf7"
    sha256 cellar: :any,                 x86_64_linux:  "2248b4b8b2e8c2a507fc16e9313d98fb938c0f41fcbae6bb31a1af17ba09f4b4"
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
