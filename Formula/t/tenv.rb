class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.16.3.tar.gz"
  sha256 "40121dbf57ca9502471a6728a906211269e11eb51939e1fa50f2e82edf2f3407"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8d4211aeb95f0f75b76b56b8a924e6bba831b7a9aac99df0da2203e1667813fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d4211aeb95f0f75b76b56b8a924e6bba831b7a9aac99df0da2203e1667813fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8d4211aeb95f0f75b76b56b8a924e6bba831b7a9aac99df0da2203e1667813fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "633b832f8eec3bdfa65c36554c0af05366748bd4f904141802ea22649a0bb7c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5975538041ab0c8be30621a0d555515d648e96646a4580ffcf66244be168adbb"
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
