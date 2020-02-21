class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.17.0.tar.gz"
  sha256 "21827ecf31ddab97d4f5a1864c1007a2e6f7ef3ebfad3bdc521acf9accc742cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "ade62fcc37f9003e5832ae511d7a5cdd7c1d4161eabeb39983071167e3be53ed" => :catalina
    sha256 "96a7d526cb69de56785652d1dc310ad506bb476e6f276f1963d5c73c74e21735" => :mojave
    sha256 "cfb4952fe183b24bbe10503ea8199c0c60e4fb5dc2d32ac4c71430a43cd141e2" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

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
