class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.76.0.tar.gz"
  sha256 "38899439182f18f03f1a70b133d3541b809f77647a0b95fcf194674aa34952f0"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c797b67619ba220a1890c829db827432702322b4bccc9cdc90582c071b33de4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "718c3e8be4799c2332841b4db900928fa344879c3470c88cf005ec52d2878fae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "94e978aaa1c830f33ab3cef5896afa6efbf3e49431cf88a5ba26b0573ce8186e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a2181a5ad9263618f756a62351818b3ea7073b00f57ea2a557a44d9cc099696e"
    sha256 cellar: :any,                 x86_64_linux:      "5784b0d3a2ce6820f5fe0578b6758dee54bacd7e8ec6a2efaa583339b298c44e"
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
