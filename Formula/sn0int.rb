class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.13.0.tar.gz"
  sha256 "98fa5a854a319177c8a41f62f7be4515fa55552554ea1afb8db729ed92f93e7c"

  bottle do
    cellar :any_skip_relocation
    sha256 "23d6a498757850c6f9331a04e8d35becaceddd3b0da10bc146ce13393c1f0451" => :catalina
    sha256 "16317c4398f79c299b4bf6af67b0c4bcfd99ac5fafe6d12f208f8aaa63c62f29" => :mojave
    sha256 "495376708f60ff095ab9519dc6a6098ab14bcf624e040461d9f86cdcab5b9990" => :high_sierra
    sha256 "60ee0081e225f90783bc480aea97a36d7cb2b63378e65af8f10201623ecf303b" => :sierra
  end

  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."

    system "#{bin}/sn0int completions bash > sn0int.bash"
    system "#{bin}/sn0int completions fish > sn0int.fish"
    system "#{bin}/sn0int completions zsh > _sn0int"

    bash_completion.install "sn0int.bash"
    fish_completion.install "sn0int.fish"
    zsh_completion.install "_sn0int"

    system "make", "-C", "docs", "man"
    man1.install "docs/_build/man/sn0int.1"
  end

  test do
    (testpath/"true.lua").write <<~EOS
      -- Description: basic selftest
      -- Version: 0.1.0
      -- License: GPL-3.0

      function run()
          -- nothing to do here
      end
    EOS
    system "#{bin}/sn0int", "run", "-vvxf", testpath/"true.lua"
  end
end
