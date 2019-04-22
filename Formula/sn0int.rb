class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.11.0.tar.gz"
  sha256 "aac73845418f7d746a9f7bfd7c14bb7762fe9c049e2a8f8fec7939fef8e4512e"

  bottle do
    cellar :any_skip_relocation
    sha256 "93e4290da3e9ef2570c60a4440364d78a6de911ddfccd31567a6656c7da772b5" => :mojave
    sha256 "0896b55d74488be908dc916b7e08bf1db2d37595a744743ead0e17660618aed1" => :high_sierra
    sha256 "66ee3201a6a8ef53bce08e969d88a3f9f75ff3e877e2672b45177b186c1a1c03" => :sierra
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
