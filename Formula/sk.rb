class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.6.9.tar.gz"
  sha256 "74a22471bca35e4c07f59c89e3332e08bb968ad734e74846505d5033a4915e47"
  head "https://github.com/lotabout/skim.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6ab938630527bafcf9e606c6064a7c1a71d914e5c17d7c85d3087eddb4dd0969" => :catalina
    sha256 "2d365a27765394204114b255530137af6f9a7827ad4229489a6a7610fa77faad" => :mojave
    sha256 "aa524091bad3ee151541200db321417bf674800fc32f7a4779fb381a5adaf575" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    (buildpath/"src/github.com/lotabout").mkpath
    ln_s buildpath, buildpath/"src/github.com/lotabout/skim"
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    pkgshare.install "install"
    bash_completion.install "shell/key-bindings.bash"
    bash_completion.install "shell/completion.bash"
    zsh_completion.install "shell/key-bindings.zsh"
    zsh_completion.install "shell/completion.zsh"
    man1.install "man/man1/sk.1", "man/man1/sk-tmux.1"
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match /.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld")
  end
end
