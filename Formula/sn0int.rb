class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.24.2.tar.gz"
  sha256 "bf89be11d09df2248df553c8f752722c9e9469956491aae391a52dfbb2233667"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cf50122ab97953746903daa429929f5431b7378b7bcf55c2fda11a3ad27d4801"
    sha256 cellar: :any,                 arm64_big_sur:  "9a25d7c4617a9cae06ab6875b7fc176ac7382dddcf34c9f2da9cdadc2bae0b55"
    sha256 cellar: :any,                 monterey:       "43329a5b327f03f639dba131e976e04133a121505f74190764befd39774d8dc1"
    sha256 cellar: :any,                 big_sur:        "e5325d4a94add1e551d235212163b8c7328d7d411376b44ed68c0bd0876c0d25"
    sha256 cellar: :any,                 catalina:       "1b15208ebdb969dcb7ddb177f5e1c725e01fc3abfe214e157cdc94faa02ee708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90ac3ed1be95895b48703463aeee1f1386a7d04ce1e1d910ccaa0fcdd2bc9808"
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
