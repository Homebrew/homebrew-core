class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "76dfbe9b31769d386f8932ead95afd98f60efd0ac0069879e86e45274e5e93fe"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c7b82c1f9494b4151fc9807825a00db33205e591b78b9271c99599cfebbb27e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71aec98b26ebdceca78f743b994dcebacbadef9c43984bda9524745433c904f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8f32020592139dae98c5cf4b2a476d1b879b0b265e819f22b7456e104a3dcde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56d420afffb8ce61c2276422ce4033e761a95c638d6711b1f30e28b878a4c104"
    sha256 cellar: :any_skip_relocation, sonoma:        "96a777701a31a8788531a957a737c81c8b8594a963821136b7fe31ee372423ee"
    sha256 cellar: :any_skip_relocation, ventura:       "bfd34239df5f6c1bc38132303bbaf7320934f38223dace37808004ec20a981f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c496e6964537e432e115820e5edb9a35cd6c8c8f3708e3734953bf63195cdeef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fd3d32455d435866ae3f8abc9a318f21e6b5d9c73676829181c532af9e14416"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
