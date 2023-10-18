class UutilsFindutils < Formula
  desc "Cross-platform Rust rewrite of the GNU findutils"
  homepage "https://github.com/uutils/findutils"
  url "https://github.com/uutils/findutils/archive/refs/tags/0.4.2.tar.gz"
  sha256 "b02fce9219393b47384229b397c7fbe479435ae8ccf8947f4b6cf7ac159d80f9"
  license "MIT"
  head "https://github.com/uutils/findutils.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "c9b20a92a27ec6e59d85ea2c7504c7b6b742a8fbce18584add667691bd8ed3a7"
    sha256 cellar: :any,                 arm64_ventura:  "8be60da1dbce8c62f921e9906b76a9f3384b0f6e7d912a26afd633ac694889a2"
    sha256 cellar: :any,                 arm64_monterey: "a6a59cb7c7e765c4df4135ddcd8766f676e70d5c08dc004f744e598bfba3481f"
    sha256 cellar: :any,                 sonoma:         "9b65bda73278dfffcb6977d9e5771bb0134050937b1b181bcee4a2308817e9d2"
    sha256 cellar: :any,                 ventura:        "a3bc5fead8a81e9c9cf771ac931f204b4fa258be83a14ffd3648c9e5267784e5"
    sha256 cellar: :any,                 monterey:       "ca68615f9cdca938f9a3d45833207603fd8a2fc9217c86fe0e79857e00c6ed8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c81b5f592d7e87310bbf175f5890e0e18a0177d2c819447021576bf8691f22a6"
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

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm@15"].opt_lib

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
