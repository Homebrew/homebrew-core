class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.10.1.tar.gz"
  sha256 "b66bd563ae811d39b3a26f0ada13945575daf4aefe8f64ba96e9d2debc4a98ec"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f02654b670182c5cd3aa30e721f1b255fba2a7765505b9c5280344f6360eb884"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f02654b670182c5cd3aa30e721f1b255fba2a7765505b9c5280344f6360eb884"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f02654b670182c5cd3aa30e721f1b255fba2a7765505b9c5280344f6360eb884"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fbb81834d269d9f38d980ee3766548f132ad1110e776fa61fdc5cae6ffe1a6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e0c09236725c1249ac0710c016d57dbacae2c8139b813b68fb158da618eee91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ec263d6f53ef1d7411f5f7f0397f3832d953ccf0ade2b852797b2f90baa149d"
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
