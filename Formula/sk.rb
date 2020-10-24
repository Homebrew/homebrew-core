class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.9.2.tar.gz"
  sha256 "0201367d671e3e31d4e3faf13dc87a7f4aaf32bbadb63b9406c500f9d8684986"
  license "MIT"
  head "https://github.com/lotabout/skim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a146d9090fbd0624dcbae55791647fb2fb940aab21cfee8f4637037b7336047" => :catalina
    sha256 "878902b610b34ddf3b20bb3e28dd446eda864c46dfccfff7d3ada2d0c9e6572c" => :mojave
    sha256 "6baa791af6658ddf2220de97d1a88d446a5a32fcf9760beb63432e7bbabf3a0e" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    (buildpath/"src/github.com/lotabout").mkpath
    ln_s buildpath, buildpath/"src/github.com/lotabout/skim"
    system "cargo", "install", *std_cargo_args

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
    assert_match /.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld")
  end
end
