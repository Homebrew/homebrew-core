class UutilsFindutils < Formula
  desc "Cross-platform Rust rewrite of the GNU findutils"
  homepage "https://uutils.github.io/findutils/"
  url "https://github.com/uutils/findutils/archive/refs/tags/0.8.0.tar.gz"
  sha256 "932f153d256f7a4cf40255a948689bf59a10f14c8804151817ab50fa1b46429a"
  license "MIT"
  head "https://github.com/uutils/findutils.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c59351876b4d6de586972073bc02e141ac57804b24e933399e10844774eafde"
    sha256 cellar: :any,                 arm64_sequoia: "c197c5ae51adde63a7d0a3770d89156032935597db27883e24d912043411bd9f"
    sha256 cellar: :any,                 arm64_sonoma:  "3cd43adf157c7f4ffe8ff244b90b7d01a42206cf3cf7dd55d314e815a2462da9"
    sha256 cellar: :any,                 arm64_ventura: "5edf7fd9d0c8f2be1ee7cb0ed463225bc1fa36dd31b04bb3127448cdd35001a0"
    sha256 cellar: :any,                 sonoma:        "f3518a5685deaf7be0e4f12d5ea7f84eeaaedcc6ec1c0d1280810a7678ee302e"
    sha256 cellar: :any,                 ventura:       "aa9cc3375d6bda074e8fb1011ef52f3ae0d0f99bcc952aa27e93e834e16af145"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1d8413308ed4eb7a6001c5dde07faaf73a96aa26e5e9d0aa6a382bcb6a64918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d595a82a20897f5ec7fbe852d50fca44f05d20e537913bf9b86aab9e2ef4e4c5"
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

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args(root: libexec)
    mv libexec/"bin", libexec/"uubin"
    Dir.children(libexec/"uubin").each do |cmd|
      bin.install_symlink libexec/"uubin"/cmd => "u#{cmd}" unless unwanted_bin_link? cmd
    end
  end

  def caveats
    <<~EOS
      Commands also provided by macOS have been installed with the prefix "u".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  test do
    require "utils/linkage"

    touch "HOMEBREW"
    assert_match "HOMEBREW", shell_output("#{bin}/ufind .")
    assert_match "HOMEBREW", shell_output("#{opt_libexec}/uubin/find .")

    expected_linkage = {
      libexec/"uubin/find"  => [
        Formula["oniguruma"].opt_lib/shared_library("libonig"),
      ],
      libexec/"uubin/xargs" => [
        Formula["oniguruma"].opt_lib/shared_library("libonig"),
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
