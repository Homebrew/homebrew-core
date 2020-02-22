class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.17.1.tar.gz"
  sha256 "230977e3eac9b052a4ef4cf4a134d58885d9884cf0412e5b91c19ecf5aab2a25"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d0a986bf8069b791bfce893831db3b8691f648c1c0b2820e0bd23b8bfdbc3a0" => :catalina
    sha256 "aa0756cdfe5c1319394a1d0476df9b3d8f40c8b528cc0fe6da110aa43329f50c" => :mojave
    sha256 "2fd22fab474792568d2d009a355ec417965eff9242da2d6905a1279208f0e07b" => :high_sierra
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
