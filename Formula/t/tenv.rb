class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "197e6b3d2b6b3b8737568c7ccebfacc072885f10ebbfc21e3d33c0f4ac1fe701"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0dc297534272ba7d7c2f75d6ab7cac84f8acd973f664cf514dbc1844b1ecc7e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0dc297534272ba7d7c2f75d6ab7cac84f8acd973f664cf514dbc1844b1ecc7e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dc297534272ba7d7c2f75d6ab7cac84f8acd973f664cf514dbc1844b1ecc7e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "6271de3152997561184c3ed3b0dea5e27c99ac2a1c3afd43cc04d3746dbe8a35"
    sha256 cellar: :any_skip_relocation, ventura:        "6271de3152997561184c3ed3b0dea5e27c99ac2a1c3afd43cc04d3746dbe8a35"
    sha256 cellar: :any_skip_relocation, monterey:       "6271de3152997561184c3ed3b0dea5e27c99ac2a1c3afd43cc04d3746dbe8a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61cc3aee3f21a4ca20e1b0ee1a70f8f9a270fb443e6378fec0f1ba87c7724d36"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", because: "both install tofu binary"
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
