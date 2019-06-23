class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.6.8.tar.gz"
  sha256 "646b43c9b4863f2d30c9e08710067816ca463fc75631b415a8763cc8c943161f"
  head "https://github.com/lotabout/skim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "69cca8d628e7c0f1196e08f5eb38a517bcd0aeecb814b06912c4a1c3eb574920" => :mojave
    sha256 "97def699425376757b322ea17ee858b64e303c638320aa89444ed63f065ec2af" => :high_sierra
    sha256 "242616b26b5d7a0fac77afd72ea42113af5ee0d49e3ea4c73c26a8207e9c6ef8" => :sierra
  end

  depends_on "rust" => :build

  def install
    (buildpath/"src/github.com/lotabout").mkpath
    ln_s buildpath, buildpath/"src/github.com/lotabout/skim"
    system "cargo", "install", "--root", prefix, "--path", "."

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
