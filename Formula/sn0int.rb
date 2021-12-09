class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.24.1.tar.gz"
  sha256 "557080235b04f47a693ed5263a7218cb5c3f5ddc273cac9185145c1bbe4b8ceb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "429da6e54ec03a70ac372adafbd8946c7e3d789f1a3e6d93a1c2512d30aea5ba"
    sha256 cellar: :any,                 arm64_big_sur:  "d087d55a98a85e0a411a5cf6df47683320df2b449998d3750ba1dfbbb6b95114"
    sha256 cellar: :any,                 monterey:       "e4cc74da30b6bfeec00982d2aa8aae8cf7ddb90c20d2c802c481e1bfeafc0249"
    sha256 cellar: :any,                 big_sur:        "d835232a9d71bc3c3f8b7f6811803cf6d2c11222964d8bda61ffc3f0571d1316"
    sha256 cellar: :any,                 catalina:       "358fd9af2fed3952846b5318cc989e28fd35e8b41c1321beac7f4d9f203c2f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f71bbd348854c63e8f0c74946d733ade3a0ce5c5f53f52fd4c05def7a52ab91"
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

    bash_output = Utils.safe_popen_read(bin/"sn0int", "completions", "bash")
    (bash_completion/"sn0int").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"sn0int", "completions", "zsh")
    (zsh_completion/"_sn0int").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"sn0int", "completions", "fish")
    (fish_completion/"sn0int.fish").write fish_output

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
    system bin/"sn0int", "run", "-vvxf", testpath/"true.lua"
  end
end
