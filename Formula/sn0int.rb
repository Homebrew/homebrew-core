class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.18.0.tar.gz"
  sha256 "12dfe19d2734a8c8c3bcd4e8e9a43e5ae58cab61cc980b7fe6fe9526e7933074"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1c6fee55547c0776a5979f97de99c1da8ac48c36ed842b033914f936eae465f" => :catalina
    sha256 "b2b0812e1d2c66f8f5f101b2690f424ff9bb3dac5f822d215ba62330392a6e83" => :mojave
    sha256 "b648960d804ed3f06b6e0f711608ecdd361dc84e867b193d9a30aecb2f294484" => :high_sierra
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
