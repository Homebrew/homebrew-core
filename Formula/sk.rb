class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.6.8.tar.gz"
  sha256 "646b43c9b4863f2d30c9e08710067816ca463fc75631b415a8763cc8c943161f"
  head "https://github.com/lotabout/skim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdb8e40fcc9420ad6086a7f5ff01d2b23b911db3eef17edbfec12154cd8ab146" => :mojave
    sha256 "c92be46e4e1b07e76178a01014271e34367a0648b5fb3712a9a1425084a314e7" => :high_sierra
    sha256 "ec22f3701080bc60e38fb813318c7416c367cb851db37b5b4ce6d28db3aeab09" => :sierra
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
