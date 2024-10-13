class UutilsFindutils < Formula
  desc "Cross-platform Rust rewrite of the GNU findutils"
  homepage "https://github.com/uutils/findutils"
  url "https://github.com/uutils/findutils/archive/refs/tags/0.7.0.tar.gz"
  sha256 "129c263c6953b5c6aa756666aa9f5e968e04c1d0315d9d8ad9e93ec3d1823bc0"
  license "MIT"
  head "https://github.com/uutils/findutils.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a2b1a4305f6c079d9ce173c0f498c6f7b2caa89598fd70ff9575ac416cb3cbe3"
    sha256 cellar: :any,                 arm64_sonoma:   "1eeebb99c9740e5ea9150fccc38a24fd8e87e5a80b9c6270059b81d10e70c6ec"
    sha256 cellar: :any,                 arm64_ventura:  "6a36f901c622e3cf5a998e8d7df717f5affe8f5a6331e347adefb87e186bdbbb"
    sha256 cellar: :any,                 arm64_monterey: "91ce728daeb833d7efe8483a47b48e7938c1f023bfe491f2144e5eac60980ba5"
    sha256 cellar: :any,                 sonoma:         "a73adc73887339585c483b4b11eef740bf31e466245fac18a842208d385720f6"
    sha256 cellar: :any,                 ventura:        "519814920c34176946e9a41fbecfa86d851c65dbcd0ea8de1ab344e16e6de38e"
    sha256 cellar: :any,                 monterey:       "97839bae94b7710646bfac19a06b20732a714b0641c4f7899fbd73a1225483f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1960b1bfa82f3b45f2df7580e15e9114a04503da577ec1cc76a02c3e2191bb7d"
  end

  depends_on "pkg-config" => :build
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

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
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
        next if check_binary_linkage(binary, dylib)

        missing_linkage << "#{binary} => #{dylib}"
      end
    end
    assert missing_linkage.empty?, "Missing linkage: #{missing_linkage.join(", ")}"
  end
end
