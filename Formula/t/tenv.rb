class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v3.2.4.tar.gz"
  sha256 "952d1059a5fe83f21655289d3d5ad0a867fe0321d92f6ca1fee880823fe78134"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dee75af08491ff73f024862d3dd012a3db5d5acaa072a30267dd200fc43a5bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dee75af08491ff73f024862d3dd012a3db5d5acaa072a30267dd200fc43a5bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dee75af08491ff73f024862d3dd012a3db5d5acaa072a30267dd200fc43a5bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "d57c944b5cfa3e1aa2dac868c6a498d9fc482dbee865fbe643c8d44c729d2e93"
    sha256 cellar: :any_skip_relocation, ventura:       "d57c944b5cfa3e1aa2dac868c6a498d9fc482dbee865fbe643c8d44c729d2e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ea3b826c848ce94ac558dc2c063570df8fca9784fe2a1db60096dbefd1d0d43"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"
    end
    generate_completions_from_executable(bin/"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end
