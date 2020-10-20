class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.9.1.tar.gz"
  sha256 "a5ae4a7955a2c3a4cbf832db32293b0467dfb52a9b38fce5bd1ac0d78a900354"
  license "MIT"
  head "https://github.com/lotabout/skim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "efada87a283b9ae7d664abd02c6cc7d426ebf139c96962655e4dbc90188b0e00" => :catalina
    sha256 "8275445e131d4806b073b857cde306d19eb7e6b1b37c7cf17d8d81b57b5698e8" => :mojave
    sha256 "d6ec21c17486089cf527ab051ddecff0401b8773cd9582bc02e0fcbdd4896538" => :high_sierra
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
