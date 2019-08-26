class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.13.0.tar.gz"
  sha256 "98fa5a854a319177c8a41f62f7be4515fa55552554ea1afb8db729ed92f93e7c"

  bottle do
    cellar :any_skip_relocation
    sha256 "34c620d12d87164aa7bbc917ec42be9a7d2e8b509311b7a34f3cfd11af5e8f08" => :mojave
    sha256 "361967842972b3c6f6b8d2febdb1a30c74101f80403bf11f5fc59dfe0ef664e7" => :high_sierra
    sha256 "af6893b50a10ef8d4f65fc1166b415b4a231dcdf65c51d283bf008c054b914f5" => :sierra
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
