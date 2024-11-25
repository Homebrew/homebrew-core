class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "a0a9e0b5c79686330a1b24d2d146844e3d9d641af01a6cac6a5e8f9c1ea2a64e"
  license "MIT"
  head "https://github.com/lotabout/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d3fd254a3ae775cc396eb82f83e66281b2c6a69d099c15af631f561b3f7aa59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f085f7a4d74d16778bb3445f535b9d593d5973ce4b900a12ab9b8b697e5eb0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e952fb2f15cbc6ef8ab67420939c450762d79fcb9606ab091852e39ce46409b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4429c940d252604f67ff93a35b9c0f570ac1bd6ead659ce6a5c0e0ea52cb6446"
    sha256 cellar: :any_skip_relocation, ventura:       "d3d07ed13608beb2c2d078ddc9e4eb7b0b123d550ea96e71dae3e5dae0c63fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c281b7fc925df7748873250870262a94a9e24843c9c160fb56054cc562cbfebc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "skim")

    pkgshare.install "install"
    bash_completion.install "shell/key-bindings.bash"
    bash_completion.install "shell/completion.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    zsh_completion.install "shell/completion.zsh"
    man1.install "man/man1/sk.1", "man/man1/sk-tmux.1"
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end
