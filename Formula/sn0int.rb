class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.20.0.tar.gz"
  sha256 "315061362aabfa3a0a8a5a15ecb06b41e8b9603cb3ef50219e4015f2ffea4184"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "c9b3cf070d01ecc5ad921e5654f5a7765e90a294e4e2bfd941a995308a4a5bad" => :big_sur
    sha256 "cc24878380598597022557113c8355f9d97cffa69665022521cbde65886a26b5" => :arm64_big_sur
    sha256 "9689b81c3e4e2a04cf05d150422949b87a7f24d219817716e2b82b58eb2191c5" => :catalina
    sha256 "d2c817bf73cb79a88c208cb22bcb7e9cc24d4d37448d3cdc1bfec7b8efbab9cd" => :mojave
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
