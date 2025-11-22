class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.8.3.tar.gz"
  sha256 "fc706d6a00534b01715fe1946dad79b2274c93db5fba9d056db07e8929482649"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa618639907cf0799f91c0f78be413fe6c9afcbb2dbe206b8986dfb6a4c2d8e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa618639907cf0799f91c0f78be413fe6c9afcbb2dbe206b8986dfb6a4c2d8e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa618639907cf0799f91c0f78be413fe6c9afcbb2dbe206b8986dfb6a4c2d8e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "29a9acac5ab6241cbf98a238bc94e5ed7d1893c70ed4db4ddd6be3091e66130f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4571053916b3bcbc0b1a8c660f6d8447c5fcf4da6a16849c3f893d5535ff000b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6c7b1cb5e083b06c1783192b392a6451e76daa24979ceb3f4fbd64f1779f131"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "terramate", because: "both install terramate binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt terramate tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"
    end
    generate_completions_from_executable(bin/"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end
