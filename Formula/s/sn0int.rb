class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.25.0.tar.gz"
  sha256 "1a0a65e22ebdea4cc9d876a794c4374354cbf4733e11427190e146d32db37d8b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b22a87efb37627da4ed66db2cab4b00211b372dc852a241cc60f0bfcd81ee5d8"
    sha256 cellar: :any,                 arm64_monterey: "3fe7d506b479e8c415233f50d779cc5adf0dc74d789e83d7fc5096da0eeffce5"
    sha256 cellar: :any,                 arm64_big_sur:  "ef3da3327700ce42227eb3b0bdcad1e00acb715c22caa46fe47950d31b0107ab"
    sha256 cellar: :any,                 ventura:        "dcc44580bf31a965415715da2bf7cb3ad2d2d8445efe2267fccb6468d0852a93"
    sha256 cellar: :any,                 monterey:       "a8f78088e4d82c0abc026a8e84015edcc9262534dbf9c03d551ac0fb9c4f4cc8"
    sha256 cellar: :any,                 big_sur:        "387b9b03ae5a1950864d29a3e4cb63c7596138a7e53f90892f482e5f49588e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "618d7b14bc76a4a3511809d06c65da23df62cc97d40a008c64b3114ad89da628"
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

    generate_completions_from_executable(bin/"sn0int", "completions")

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
