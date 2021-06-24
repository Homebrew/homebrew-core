class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.21.2.tar.gz"
  sha256 "f76ac3311a123431b17222b1e6de656604c338a4bb3c567137dde7a211e5d906"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "0cae34bb3550466cc2706bc0fcb636ed964217252a35e77f18bddfd46de8ff47"
    sha256 cellar: :any, big_sur:       "919fc70b0606663155a873ebbb02e97a782d6fc638116fb315c39a66c53c93ea"
    sha256 cellar: :any, catalina:      "a217f108e992a91d99438f37c06c6859f957e50fba065b91e0c09e0100107e5f"
    sha256 cellar: :any, mojave:        "380a8a3e38ed826704ca6485d622695ed6a3b270321c7854233804f05af3656e"
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
