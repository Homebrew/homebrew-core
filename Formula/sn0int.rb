class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.9.0.tar.gz"
  sha256 "53e41ea299b4be6c999d2410c7ba5ae9cba48fef58e0778318e321c1090f4c0e"

  bottle do
    cellar :any_skip_relocation
    sha256 "36f28ef3002a3cf77f0617979528b39c4a4087fe2d42e5f40ed7576075952a52" => :mojave
    sha256 "9322ce859cccb92d18bb512ce602c0527a448d2dba92703b2b77e14770fa3150" => :high_sierra
    sha256 "2ddd6e6de3e9b0be8231a58df745261bdc4b82cea0dbbbf147f9cc8202a2521e" => :sierra
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
