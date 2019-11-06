class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.13.0.tar.gz"
  sha256 "98fa5a854a319177c8a41f62f7be4515fa55552554ea1afb8db729ed92f93e7c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "010e3a11a2ef850f780d350e1f0da232dcbc032ef5c6b442d79dc2f950b804af" => :catalina
    sha256 "cf6005ad1e1ee1926b19e8a2d6d11dc2e8f84814cfd5ac785431645641f5ba1b" => :mojave
    sha256 "1cdb6d0437e56d58276e193a42e7b7256a9079f86711f5de3daf45edf8314a41" => :high_sierra
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
