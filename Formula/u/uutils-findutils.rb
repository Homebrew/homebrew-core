class UutilsFindutils < Formula
  desc "Cross-platform Rust rewrite of the GNU findutils"
  homepage "https://uutils.github.io/findutils/"
  url "https://github.com/uutils/findutils/archive/refs/tags/0.8.0.tar.gz"
  sha256 "932f153d256f7a4cf40255a948689bf59a10f14c8804151817ab50fa1b46429a"
  license "MIT"
  head "https://github.com/uutils/findutils.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6eb3e88da89772a813c0147b7c3a0f62832b7661ff428c6c2fdbf52a03d63593"
    sha256 cellar: :any,                 arm64_sequoia: "0a7c3c5b37302609771a28be11cc84443a759ecd8825c3ee1532f578d3428ba6"
    sha256 cellar: :any,                 arm64_sonoma:  "1e2926212ba80f571e8a9c9a4e240e2418c828d28a4c73afd11263771c78f522"
    sha256 cellar: :any,                 sonoma:        "4504ecdf9e500e9bc9c56ebacd087bd056fab8d0e039e7cdc6021e9d3ac82afb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a3d9faebb6fa34813ab9f17a87f2a10e68a5f08267791487d70e1a09376da5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2edddc168292e0f75bde8380d1e6ff5f11c053f9aeb9d25752ce327410083bd2"
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
