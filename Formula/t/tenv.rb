class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.15.1.tar.gz"
  sha256 "dcdc001456b1a3d5d2f680f20cb4ef3f049eb17d9def9abc96b0303c6b16b99f"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c00d676a520557da303dd5c5b935b743fecccfbe0dde580a45df709757530d74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c00d676a520557da303dd5c5b935b743fecccfbe0dde580a45df709757530d74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c00d676a520557da303dd5c5b935b743fecccfbe0dde580a45df709757530d74"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6e5a0efc047cf8d30dc20fd98e5110c2a3638890bee1f0b33246c55c18313e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cce50f66d1dce85930c5b9d2712d1e1067f553ca764f475a353861d4e229ce9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1826eb6b2ab65c9a9bc2143b2bbe6e79d8bfa22cbbbaebb295ad54aa4f6163b"
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
