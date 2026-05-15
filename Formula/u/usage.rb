class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "632492afeca1b86955d7779ae895085d73837bc4bfce9e4eb94b90b06c825d70"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f15b403cbef1002103d425e5548a2f79e3948015019b3a6ec35c8bc39d277819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe4d86d2a237452349d103dc4418a0a4a3dfae8298bf18f042dbef40a209d3be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12be6f50be325f659ba2bbace15caf275208f444123a5d5f69cd81b6e276976d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e2d7cf9cae1511d27c43ec6407d01a89d77f3568b3eb19aecb9a69010f17ee2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec6e3a94c6e2f161c3f5badeb4121d90d0e5daf8da907e81c363759211878eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68a16bfabfce5104423b286bdcf00a9831aa11434a868562fff4290aea978cf4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
