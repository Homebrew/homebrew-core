class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.22.0.tar.gz"
  sha256 "acc65e1ba4d2c117e03d4c4064b9121f7b3aef16562329ffced06cc75d598b34"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b92b03632a362c9e58bf520f2b32aa3f4cd1adedca52227d4dfac77612412b46"
    sha256 cellar: :any,                 big_sur:       "0feb4eb85dc71fb422586160548a2f1ab7859db2960ae3832b7684b235d5e1fc"
    sha256 cellar: :any,                 catalina:      "ee81122a7fdb127d319635582d5daaf68ce5e9f9d7ff42a2774d9732d27e6c0a"
    sha256 cellar: :any,                 mojave:        "5a3bee08093299cd1cc454de68927afa595bdfb122c77f97ca5df7a94ae6a41c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b85c6416f70c5021bc56515d3a0405cf7616400df7b4eb507759128cf6a30f7c"
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
