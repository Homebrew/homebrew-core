class UutilsFindutils < Formula
  desc "Cross-platform Rust rewrite of the GNU findutils"
  homepage "https://uutils.org/findutils/"
  url "https://github.com/uutils/findutils/archive/refs/tags/0.11.0.tar.gz"
  sha256 "43d1fbb69a0e67e708435bd104966d1dd61357755452b733db9dabfd66cbf974"
  license "MIT"
  head "https://github.com/uutils/findutils.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "13aa41b6dc8193d4384839047e857168c29105a3a07984f8c8ffd871fb1a8d80"
    sha256 cellar: :any, arm64_tahoe:       "ffab93a4a672cf3fea6c6184cde73db7f28b6c825f4b9ee28f38578aeddbdd48"
    sha256 cellar: :any, arm64_sequoia:     "14bc09b33c21300ad37c0396695b97a12c4a7cbf6330ab2fba8fc88a044e61e0"
    sha256 cellar: :any, arm64_linux:       "439de0165b45974a6f7b818db67400e99d112ee5fe57bd4549d3cd51d7f3171f"
    sha256 cellar: :any, x86_64_linux:      "9572af4e16dc04cf1c96bf9aefd6f71548d71062fd02e47d7c0bb42eb562139a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  uses_from_macos "llvm" => :build

  def unwanted_bin_link?(cmd)
    %w[
      testing-commandline
    ].include? cmd
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args(root: libexec)
    mv libexec/"bin", libexec/"uubin"
    Dir.children(libexec/"uubin").each do |cmd|
      next if unwanted_bin_link? cmd

      bin.install_symlink libexec/"uubin"/cmd => "uu-#{cmd}"
    end
  end

  def caveats
    <<~EOS
      Commands have been installed with the prefix "uu-".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  test do
    require "utils/linkage"

    touch "HOMEBREW"
    assert_match "HOMEBREW", shell_output("#{bin}/uu-find .")
    assert_match "HOMEBREW", shell_output("#{opt_libexec}/uubin/find .")

    expected_linkage = {
      libexec/"uubin/find" => [
        formula_opt_lib("oniguruma")/shared_library("libonig"),
      ],
    }
    missing_linkage = []
    expected_linkage.each do |binary, dylibs|
      dylibs.each do |dylib|
        next if Utils.binary_linked_to_library?(binary, dylib)

        missing_linkage << "#{binary} => #{dylib}"
      end
    end
    assert missing_linkage.empty?, "Missing linkage: #{missing_linkage.join(", ")}"
  end
end
