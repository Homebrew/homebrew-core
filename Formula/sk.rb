class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.8.0.tar.gz"
  sha256 "42ac516aba6c9116fe96ff9dc5ac22fc7b14f809fbcdb5aaf93b9b36955da4dc"
  head "https://github.com/lotabout/skim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97266181b984acb103b778f8382dd7eb17c5dc7c687cc7d2ac1c530cfbf9e32b" => :catalina
    sha256 "fa190d3195836349184d5876891ad44c582d8806287a138a4a4581350e5f57e4" => :mojave
    sha256 "ee860f4cd146ebb209bdbee52bceba78fd7b80a5ad121ee939eb5f6c179eef16" => :high_sierra
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
