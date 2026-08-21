class UutilsDiffutils < Formula
  desc "Cross-platform Rust rewrite of the GNU diffutils"
  homepage "https://uutils.github.io/diffutils/"
  url "https://github.com/uutils/diffutils/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "4c05d236ebddef7738446980a59cd13521b6990ea02242db6b32321dd93853ca"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/uutils/diffutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3335444221ff7d6756894ed48088e1a5b1c702699bb903f6631b8141ca384618"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16b1308ebadbc4934d36a3b2a1a4394abc1534aefa2d7255a18d85d9e6bd7cdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a9e4412033cc45d68bd1757e7349199c58c91b585c272386321a475ea5fc0d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d75c01d3d68f9fca442a8586c12d20928d5c7f04996ac3f1d1f23206a746d62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c96ae075a0ecf59313598b7c69f22cc41c3dbfd66b43d76c0813c35eb0a01d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d1e9f3d5321efbd029288b90b287d8321ffc29e8dde1dbb203ae8a67db56bbf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(root: libexec)

    uubin = libexec/"uubin"
    diffutils = uubin/"diffutils"
    mv libexec/"bin", uubin

    # Supported commands from https://github.com/uutils/diffutils/blob/main/src/main.rs
    %w[diff cmp].each do |cmd|
      odie "Check if manual symlinks should be removed!" if (uubin/cmd).exist?

      uubin.install_symlink diffutils => cmd
    end

    # Need an exec script as symlink name is used as first argument to `diffutils`
    uubin.each_child(false) do |cmd|
      bin.write_exec_script uubin/cmd
      bin.install bin/cmd => "uu-#{cmd}"
    end

    # Expose `diffutils` without prefix as it does not conflict with system executables
    bin.install_symlink diffutils

    # Create a temporary compatibility executable for previous 'u' prefix.
    # All users should get the warning in 0.5.0. Similar to brew's odeprecate
    # timeframe, the removal can be done after 2 minor releases, i.e. 0.7.0.
    odie "Remove compatibility exec scripts!" if build.stable? && version >= "0.7.0"
    (bin/"udiffutils").write <<~SHELL
      #!/bin/bash
      echo "WARNING: udiffutils has been renamed to uu-diffutils and will be removed in 0.7.0" >&2
      exec "#{bin}/uu-diffutils" "$@"
    SHELL
  end

  def caveats
    <<~EOS
      All commands have been installed with the prefix "uu-".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"udiffutils", "diff", "a", "b" # TODO: remove in 0.7.0
    system bin/"uu-diffutils", "diff", "a", "b"
    system bin/"uu-diff", "a", "b"
    system bin/"uu-cmp", "a", "b"
  end
end
