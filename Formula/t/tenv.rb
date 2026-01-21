class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.9.0.tar.gz"
  sha256 "c8cb262f7e851ea70e083390928959ee85d1e5bdacabe255515b479044f21a77"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba012cb4aa497e16c74cedcdbc73985833b5b68e446359dc42c0818d92cadcb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba012cb4aa497e16c74cedcdbc73985833b5b68e446359dc42c0818d92cadcb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba012cb4aa497e16c74cedcdbc73985833b5b68e446359dc42c0818d92cadcb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "84279c6c46997ad972f50376d20af6caa7c8531a1a0160930fd29fe9573c4494"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b62bd907c933a33db60ad630713b2341103a8370773274850403cd8df97a5a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9a1c1fd851a368459edcf1a299713a1fac7260b09703159347bb3f989aa8b5f"
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
    generate_completions_from_executable(bin/"tenv", shell_parameter_format: :cobra)
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end
