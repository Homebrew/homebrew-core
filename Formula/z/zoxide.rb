class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "e1811511a4a9caafa18b7d1505147d4328b39f6ec88b88097fe0dad59919f19c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "964e6255290fc811c6cd48fbaa64c43aae2c02ff3428a9e3f80f0edbc80c813f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56cffdc072dc292ff685eb356dd749989d11ddaa61ea25d9f491c366f1233fe0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ae8e0ad889364e1c61e2e0e66abf2961758ca26893e76a00e771eba4a83ae4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5bd1154c5fcb0fc2bfa696a22e7d5ee25ae83a7c3f06c27b155080c493f110d"
    sha256 cellar: :any_skip_relocation, ventura:       "b311dbb14fadb2c043c5328b2b646d2224cac3a5abe522bf881b5ac0ab4bab9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aec49f52a6ebf297cb4b1ab2f04a34cde413606979e017b27f92fb7ca3812c64"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "contrib/completions/zoxide.bash" => "zoxide"
    zsh_completion.install "contrib/completions/_zoxide"
    fish_completion.install "contrib/completions/zoxide.fish"
    share.install "man"
  end

  test do
    assert_empty shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
