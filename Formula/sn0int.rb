class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.22.0.tar.gz"
  sha256 "acc65e1ba4d2c117e03d4c4064b9121f7b3aef16562329ffced06cc75d598b34"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "292bc7f13087ef8d3f60bfbb2f532c4590f5e59559ebcc5efbb09721721adcd3"
    sha256 cellar: :any,                 big_sur:       "047c660782189a8708c3478a0a6c2d9fbd949cf95fcc91f678fde0d24ed324c0"
    sha256 cellar: :any,                 catalina:      "991fd7b49994a29fe6596f1d3dd56104719feb9bf15d865ce7e58ba823e9ea7e"
    sha256 cellar: :any,                 mojave:        "863e8f5dc164cb0345fcf74b8e5bd209a2684697daa0546fffbccdb2c3ac96c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "049c9be04a7a837b276b84f9cc036f24f42a37949a3d32854bf4a71f65e19628"
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
