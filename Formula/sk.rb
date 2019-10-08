class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.6.9.tar.gz"
  sha256 "74a22471bca35e4c07f59c89e3332e08bb968ad734e74846505d5033a4915e47"
  head "https://github.com/lotabout/skim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "07c0429bb359f72146b2946a82101e098f5ad66a4b8dc5288622318803d23e1f" => :mojave
    sha256 "3e7defd00df8de655483c2ac2f5d3d25010daed0a1e20852546e955bb1ef8cc2" => :high_sierra
    sha256 "62c49fac31c7be30aea9e4345c3ba1b9d3c876c38b437f1ad721e49fdd49373a" => :sierra
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
