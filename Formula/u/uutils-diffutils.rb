class UutilsDiffutils < Formula
  desc "Cross-platform Rust rewrite of the GNU diffutils"
  homepage "https://uutils.org/diffutils/"
  url "https://github.com/uutils/diffutils/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "74f9c60ae86a63433bc82190e473b943057153d63f6ad39e646cc84350a3d9fa"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/uutils/diffutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1b99f078a13698d9ed06a58ba269ced21ce3551a7f663ca064b8209054858521"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5689d88d3ec393f1eca17f414d633012cd044fa3da32ea96b3865e6135e2a31b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "63525ac11be40a238d06287094494f56603bb8e64dba9c87dcbd2aef80fe041e"
    sha256 cellar: :any,                 arm64_linux:       "a2094f9bfcff654710eb30e076aca2921943719f8cc52db2b151d067c1bbbd5b"
    sha256 cellar: :any,                 x86_64_linux:      "52a32466d9aa4d6c384904133d00ba3efa5a8ce204b162d52fac2e990690aea1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
