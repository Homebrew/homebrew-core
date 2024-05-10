class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "ec002bdca37917130ae34e733eb29d4baa03b130c4b11456d630a01a938e0187"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f676f976bc36f800fb3e1501dac29b579493d4cfe09217bd9a7a78d7a6289ed3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e0633546aacf6a5b61e8f4f3a3267fc2fe20437bdef451523bf6f6280441bc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a8eb375e99c59cd6f24432d3dd80d4ad7d6e79f43de93c215cfa79f7a27ff33"
    sha256 cellar: :any_skip_relocation, sonoma:         "117d3d68c603514fd9c0db890f2cfb6337748b897e15d0f60ff1f80adcf72535"
    sha256 cellar: :any_skip_relocation, ventura:        "c57845be5b2e1c2b1c0a1830ea238790be6010ac8471bff993e52e29e3588a38"
    sha256 cellar: :any_skip_relocation, monterey:       "599d8d2fcd5f2dddf52ba4815bb310e3344f2b30bae902a6aff8956ef4991f1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "778fb5fd4766a8a149ad721195b626bf7efc8d11da7ae15b9a5d95a2b5a07365"
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
    assert_equal "", shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
