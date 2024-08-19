class UutilsFindutils < Formula
  desc "Cross-platform Rust rewrite of the GNU findutils"
  homepage "https://github.com/uutils/findutils"
  url "https://github.com/uutils/findutils/archive/refs/tags/0.6.0.tar.gz"
  sha256 "b566fcd1221d751bbf2edf86dff8a76276981a6c051f05c128b56cbfe714436f"
  license "MIT"
  head "https://github.com/uutils/findutils.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d3944ebe0c82d0151e0fd092266ba86618f34c08ddf4dd4fd2f16b792431d609"
    sha256 cellar: :any,                 arm64_ventura:  "8331b8648c2d5447a1f57da797a80e3bcd702e56e4fc25c878683d5e98de86ff"
    sha256 cellar: :any,                 arm64_monterey: "b59e76166262232f7d63d5a59661637e72df9db1f5db29bcdc0e4fc4a5fe3a7d"
    sha256 cellar: :any,                 sonoma:         "102cad8f61ad4b53485fef909a43c036c5862a39839365a84ec594477a781af6"
    sha256 cellar: :any,                 ventura:        "2b74e231e6115306d2b30781d46716295173dfd46f04fdb6062740d58246eeab"
    sha256 cellar: :any,                 monterey:       "e55692c4d1e66f6ab7988d2a7e320049279d91abd84d9dbae5070fe908c6e171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daba8b8ba50c00f9425cdf7a742c7eca2397c466767e623b3d12be6f84f292cf"
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
