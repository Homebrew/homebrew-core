class UutilsFindutils < Formula
  desc "Cross-platform Rust rewrite of the GNU findutils"
  homepage "https://uutils.github.io/findutils/"
  url "https://github.com/uutils/findutils/archive/refs/tags/0.9.1.tar.gz"
  sha256 "ac60fa34c09110a386c3782e94f5ca3f9294f64edf82855637c630c36de65ed3"
  license "MIT"
  head "https://github.com/uutils/findutils.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3ad05549b7514c55b367f56b3f6bc6d34b29f854d604989fe8fc5159fb554ec9"
    sha256 cellar: :any, arm64_sequoia: "48234236e97ec3b23a125571f8e97f4b47b19fb79fa5bdf1e3b5c29c7aed200c"
    sha256 cellar: :any, arm64_sonoma:  "a6b024849ec54e2d910f7890d8d9826cb1ab6e47f059e3e5828e8179a7082a7c"
    sha256 cellar: :any, sonoma:        "9a88974f86159b84dd5620ea0f101405e196edcd9bbbe5d17568f662f5c17f2a"
    sha256 cellar: :any, arm64_linux:   "ba6c49a8944492a4fb4004014db33229d5b1c1e6e261939e04be128b52e7e7f0"
    sha256 cellar: :any, x86_64_linux:  "98829d94828c779fe9e466de878002b00df91493acb92aa2121a592da8ad1d6d"
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
      next if unwanted_bin_link? cmd

      bin.install_symlink libexec/"uubin"/cmd => "uu-#{cmd}"

      # Create a temporary compatibility executable for previous 'u' prefix.
      # All users should get the warning in 0.9.0. Similar to brew's odeprecate
      # timeframe, the removal can be done after 2 minor releases, i.e. 0.11.0.
      odie "Remove compatibility exec scripts!" if build.stable? && version >= "0.11.0"
      (bin/"u#{cmd}").write <<~SHELL
        #!/bin/bash
        echo "WARNING: u#{cmd} has been renamed to uu-#{cmd} and will be removed in 0.11.0" >&2
        exec "#{bin}/uu-#{cmd}" "$@"
      SHELL
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
    assert_match "HOMEBREW", shell_output("#{bin}/ufind .") # TODO: remove in 0.11.0
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
