class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.19.1.tar.gz"
  sha256 "4720736805bec49102f0622ba6b68cc63da0a023a029687140d5b4d2a4d637dc"

  bottle do
    cellar :any
    sha256 "3e12b016b139a4373082529dbf77822bc755fa2927b3e73b9aba8667ec856d6f" => :catalina
    sha256 "53d2458b891d16ba202cadd1b2f3ee3c88bf84a65a892048c2dc3099b2fa4a6a" => :mojave
    sha256 "dd95c72edd23b029078118311ac2865915801eeeeb08067184721bdc7d8db4bf" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build
  depends_on "libsodium"

  uses_from_macos "sqlite"

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
