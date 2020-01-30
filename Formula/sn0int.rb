class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.16.0.tar.gz"
  sha256 "d81f883802807bef787262cbd5f4aa1f87b82fb17c01698ce9d883287d2112af"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d295b60c582fa507bc91eead8a3c6e158eb10b376f959b698ffc340014dcaa8" => :catalina
    sha256 "3a1c89314cbba6b30faae25982886d49bc50fbd8a230855cddb7f393b831ebeb" => :mojave
    sha256 "835293cc217458201799d60e59091e49e7cdd0aebd025220eec8b88d97865b96" => :high_sierra
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
