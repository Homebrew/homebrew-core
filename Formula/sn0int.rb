class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.23.0.tar.gz"
  sha256 "38600bfb1df61f0640f52ab23b990eb25cd422df95af30bf1d290fb455849a95"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "26726fcff875d9bf48aaf82d10199c3d835675f4796863fc44786b0b8950d5b2"
    sha256 cellar: :any,                 arm64_big_sur:  "917c9cb08c392e891d5c7b8d6cc712fb98681769466c99b32aaa1654bd90570a"
    sha256 cellar: :any,                 monterey:       "bd744522f273266e8e2d9c2b2c690373b17cc3567e68202c0c12b7305b7c6e3b"
    sha256 cellar: :any,                 big_sur:        "72813ea3748851d0d6afdf7ccc9529be510a40bf5aea9d6f0e88ed45011594f0"
    sha256 cellar: :any,                 catalina:       "b1768826a0d1558668fe80c8a189ce37d4050722cb3e09591a771ea00565c5b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c709f2f83a1b8d38f239c2b2239cebf74358785f757d1b58819d802951d55877"
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
