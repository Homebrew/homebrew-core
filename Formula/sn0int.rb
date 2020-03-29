class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.18.2.tar.gz"
  sha256 "5040641ff7954ba7bf663312be06b99d2fa53d6d05ccdd0afa235fa8e2dafe2a"

  bottle do
    cellar :any
    sha256 "a0b4bd448acc6f09927627b9ada2855fb8b5935c1d4f4a01b59e6c6111a03c03" => :catalina
    sha256 "d66000fae5a10b794b32ab72be417815a8711c7f968f1f6de4664045c62c6cbc" => :mojave
    sha256 "2270f47c557370e5572ea5762db6451c253ec2156ece411783a556fc8aa538c1" => :high_sierra
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
