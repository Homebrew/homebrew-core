class Tldx < Formula
  desc "Domain Availability Research Tool"
  homepage "https://brandonyoung.dev/blog/introducing-tldx/"
  url "https://github.com/brandonyoungdev/tldx/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "b0e90ffe2ccc6d7175fdac8ad7fa9c289cd22c3655219b873b4ad7f1010af248"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d44a663ef699c960834486193e166e37149f7c421d1440365549ea9b9420807d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d44a663ef699c960834486193e166e37149f7c421d1440365549ea9b9420807d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d44a663ef699c960834486193e166e37149f7c421d1440365549ea9b9420807d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d19cea7241cb4d7cf3cb3c62a50d0f3952f4ddff53acad8d231ade94b3417499"
    sha256 cellar: :any,                 x86_64_linux:      "8af4f5590e817403bcaa431e7871ba1ce143b9014ff76140e2e447390300a145"
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
