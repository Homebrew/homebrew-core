class UutilsFindutils < Formula
  desc "Cross-platform Rust rewrite of the GNU findutils"
  homepage "https://github.com/uutils/findutils"
  url "https://github.com/uutils/findutils/archive/refs/tags/0.5.0.tar.gz"
  sha256 "609ab3fdbf5a3ec8c3a3f014715d3f930e55a217915871a2861e0567c7be76d5"
  license "MIT"
  head "https://github.com/uutils/findutils.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "12b5ed3eac76496fa83f17702d24b11780c8c4031ad0b7f533f2d1417cbe59d2"
    sha256 cellar: :any,                 arm64_ventura:  "2efbfd98b7bd2f911537e1678efdebbd220301c5f9a432add77e03a2dd3b06a4"
    sha256 cellar: :any,                 arm64_monterey: "77f731f7daf405a9c353383908404522b28696f044d1ca4f5b350a7ec2395ffe"
    sha256 cellar: :any,                 sonoma:         "0aa0883840290ac57612e718cb96757bc455f563be3124d01fbd8b86dea6d28e"
    sha256 cellar: :any,                 ventura:        "74aef463704c438d36d16da8673a575e9d154143282fb17644f6b3f8097f312e"
    sha256 cellar: :any,                 monterey:       "53c8dd5b4120465a9befd73b93894d35d5534e2d8d1c44acdfd82df4b167e382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "786493398d788145040daa91d3f72f1cf53184bb318edb070c8fc88df5fba2a0"
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
