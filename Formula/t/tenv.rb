class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "a5a2f208fe3cf9168d19ad322ce9176d94030f4a2bdb3a7180bec0dec25c3da5"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "705c5d5fa9ccfbe667f9171b67ecf409848b05657d9f225162fdbf4d896bc141"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "705c5d5fa9ccfbe667f9171b67ecf409848b05657d9f225162fdbf4d896bc141"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "705c5d5fa9ccfbe667f9171b67ecf409848b05657d9f225162fdbf4d896bc141"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7fddd8517b9dc1b145168795966b94c9fac1a5d030c3cd79afc324727435863"
    sha256 cellar: :any_skip_relocation, ventura:        "e7fddd8517b9dc1b145168795966b94c9fac1a5d030c3cd79afc324727435863"
    sha256 cellar: :any_skip_relocation, monterey:       "e7fddd8517b9dc1b145168795966b94c9fac1a5d030c3cd79afc324727435863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09ecce584a095b3af3ddca6bdadff25aaba02b4449749caea1aaed06bfe812bf"
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
