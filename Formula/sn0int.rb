class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.11.2.tar.gz"
  sha256 "11c527f8ee2e338f9233226c5427a0a3e598146df9498711e1012586751f240a"

  bottle do
    cellar :any_skip_relocation
    sha256 "9078cd2ed5f441fa75519df7a405d7df40fe383297d30b9c12cc789f6e600ef9" => :mojave
    sha256 "909af42796a2c63ecc919b953c8addf839da38307b5eaad3f17acc1a729e07c6" => :high_sierra
    sha256 "1bb9d38083a7c3cd57a4e19166e22ecf8e16c2ee7d5f80621c3f34a5349ee00a" => :sierra
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
