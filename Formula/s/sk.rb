class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v5.6.5.tar.gz"
  sha256 "ec846755e5f818d9804e18137c936d0d2b07281cd7a77e29c1319d34037882ac"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e9e007703718d0ede5a3f834585d461af086e29eb591fc565cea40c9149e7da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2273aa51c915975fb9b2eb81d18d3cce8c9e4970424b5c30a756a570c0028115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99d9bb128ccf5bc7f7399c339ce05d1b5e57bfdeb8225d8e1dbe1c313de178d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "69a0f90b250da300e35c954ff6178da1c5f03b27c1c9a901518947022d916c4e"
    sha256 cellar: :any,                 arm64_linux:   "fb66d349274427246432e7ec52a649e932262f82a974266fd36844548fff86c9"
    sha256 cellar: :any,                 x86_64_linux:  "4089f68556caca5c32ebd60c5295afe1a048e220e5c3a55d322eaee2f63cd052"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sk", "--shell")
    bash_completion.install "shell/key-bindings.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    man1.install buildpath.glob("man/man1/*.1")
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end
