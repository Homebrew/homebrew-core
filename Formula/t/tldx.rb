class Tldx < Formula
  desc "Domain Availability Research Tool"
  homepage "https://brandonyoung.dev/blog/introducing-tldx/"
  url "https://github.com/brandonyoungdev/tldx/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "b0e90ffe2ccc6d7175fdac8ad7fa9c289cd22c3655219b873b4ad7f1010af248"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a262edd820c6a4002c15b10de07f1ca299232264cb5abe2215c35da064c7277b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d96a7979e2ebc00c5d405321e0f6d0c4b578a6da13fa9ac52e53c8b11a83aed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d96a7979e2ebc00c5d405321e0f6d0c4b578a6da13fa9ac52e53c8b11a83aed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "2d96a7979e2ebc00c5d405321e0f6d0c4b578a6da13fa9ac52e53c8b11a83aed"
    sha256 cellar: :any_skip_relocation, sonoma:            "00858ec307fc0527a439811f40f049f0f2941e8f7f434131050e11561caa5857"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a89ae4fa36082949479c206ec2db630a2b522ef14972850b448414976f45142f"
    sha256 cellar: :any,                 x86_64_linux:      "c56108174a82639b23b5edc1b56f22379105e3cacfed365b484633ed0afe7ed9"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/brandonyoungdev/tldx/cmd.Version=#{version}")
    generate_completions_from_executable(bin/"tldx", shell_parameter_format: :cobra)
  end

  test do
    assert_match "brew.sh is not available", shell_output("#{bin}/tldx brew --tlds sh")

    assert_match version.to_s, shell_output("#{bin}/tldx --version")
  end
end
