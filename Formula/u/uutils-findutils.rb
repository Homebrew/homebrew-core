class UutilsFindutils < Formula
  desc "Cross-platform Rust rewrite of the GNU findutils"
  homepage "https://github.com/uutils/findutils"
  url "https://github.com/uutils/findutils/archive/refs/tags/0.4.2.tar.gz"
  sha256 "b02fce9219393b47384229b397c7fbe479435ae8ccf8947f4b6cf7ac159d80f9"
  license "MIT"
  head "https://github.com/uutils/findutils.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "b2d4ebf4a5d4079307a9194c0de2f97365866c810361d494ac89dd44e8854e77"
    sha256 cellar: :any,                 arm64_monterey: "1d12336e8576070509a6934ec3392ae7e6721ecff4078c42304fa9beb6ac3bb7"
    sha256 cellar: :any,                 arm64_big_sur:  "821c3aa45921a61bd90ba37824fbe4744ae05aac7306e8a73f1b1f345b5098f1"
    sha256 cellar: :any,                 ventura:        "b3b25561744df530c87603c7e77144945bc49405862818739307bd190d8f0e88"
    sha256 cellar: :any,                 monterey:       "8fe723a29bf22921d4ff4cc899cc3d59d6b62ab56963d6bc125d2b0ac16fef29"
    sha256 cellar: :any,                 big_sur:        "9017c63a62a1db58789b5e169ba7fb1b7fd2a4d29ef2bb890d475915e3d02a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a03fc5f016bd6c98e2ec90889ecc2cb55d89e4bfc146c10fb746411f4b5341c2"
  end

  # Use `llvm@15` to work around build failure with Clang 16 described in
  # https://github.com/rust-lang/rust-bindgen/issues/2312.
  # TODO: Switch back to `uses_from_macos "llvm" => :build` when `bindgen` is
  # updated to 0.62.0 or newer. There is a check in the `install` method.
  depends_on "llvm@15" => :build # for libclang
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def unwanted_bin_link?(cmd)
    %w[
      testing-commandline
    ].include? cmd
  end

  def install
    bindgen_version = Version.new(
      (buildpath/"Cargo.lock").read
                              .match(/name = "bindgen"\nversion = "(.*)"/)[1],
    )
    if bindgen_version >= "0.62.0"
      odie "`bindgen` crate is updated to 0.62.0 or newer! Please remove " \
           'this check and try switching to `uses_from_macos "llvm" => :build`.'
    end

    ENV["LIBCLANG_PATH"] = Formula["llvm@15"].opt_lib.to_s
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
