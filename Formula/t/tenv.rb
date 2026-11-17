class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.16.9.tar.gz"
  sha256 "e82fc7cf1cf6030f4056658ae870d0ef9a728f69c5d9997f5e46c738827b490c"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0536588a82be4d2620de9d22490f86a550797c8c3448e56ab9880fd2d499a5a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0536588a82be4d2620de9d22490f86a550797c8c3448e56ab9880fd2d499a5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0536588a82be4d2620de9d22490f86a550797c8c3448e56ab9880fd2d499a5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9e9562c2a646fc1e4986ff265d2e7e15e29a11df0a5ae2e187c5490e6ab1f815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "76f7ed15ea1de607c50e7aee32a285c2d28cf6c40f5b0e30767b465f99746daf"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "terramate", because: "both install terramate binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  # `test do` block queries GitHub releases
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X main.version=#{version}"
    %w[tenv terraform terragrunt terramate tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"
    end
    generate_completions_from_executable(bin/"tenv", shell_parameter_format: :cobra)
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end
