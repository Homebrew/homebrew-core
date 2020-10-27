class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.19.1.tar.gz"
  sha256 "4720736805bec49102f0622ba6b68cc63da0a023a029687140d5b4d2a4d637dc"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5a6cc5bdf07a29ebf714aff83d338394d030780aaf69dda387499ca0db8138f2" => :catalina
    sha256 "75c89017e8f92cc2ef2a1701554a2047ec1a4a42806bc47081c7af42935a8043" => :mojave
    sha256 "0cf32130ed1155b959935202031f7d71c34f141a46c726233836e402c9bd8bc8" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build
  depends_on "libsodium"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "libseccomp"
  end

  def install
    system "cargo", "install", *std_cargo_args

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
