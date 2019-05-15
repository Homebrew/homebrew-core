class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.11.0.tar.gz"
  sha256 "aac73845418f7d746a9f7bfd7c14bb7762fe9c049e2a8f8fec7939fef8e4512e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b857fb412338e25e9d77757d4098cc2aeae130918dad9d8be561b4e061665fa3" => :mojave
    sha256 "3f1c3f663ff59dcd4c0ee67ba0d6ad52a8dfc4be03f4565ba81a420e4de48263" => :high_sierra
    sha256 "a1a9841bf1b1fb10ecffb234db292b4625d494dda8908f9da926726308fbadab" => :sierra
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
