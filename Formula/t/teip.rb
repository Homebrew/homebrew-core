class Teip < Formula
  desc 'Masking tape to help commands "do one thing well"'
  homepage "https://github.com/greymd/teip"
  url "https://github.com/greymd/teip/archive/v2.3.0.tar.gz"
  sha256 "4c39466613f39d27fa22ae2a6309ac732ea94fdbc8711ecd4149fc1ecdfbaedf"
  license "MIT"
  head "https://github.com/greymd/teip.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "b8236a3ce68ab2062bf453517e5eeee3ca58edd543db01c1065bab68913d5419"
    sha256 cellar: :any,                 arm64_ventura:  "3318cc516cddaa7ab4a31c63edfe1db4a1e911d846c06fa47f582af4b4b36edb"
    sha256 cellar: :any,                 arm64_monterey: "88b1bd22cd5f91736a977181d132ce58aeac3ddbad78a72fb58d50cf8b49e45a"
    sha256 cellar: :any,                 sonoma:         "8e469e75ba52cafb414cda79b1577d6a7a0092a97cfc3a192e8546fd5695c417"
    sha256 cellar: :any,                 ventura:        "1fa2d3d2b009360140e0990c12558ce68843793a560443aed94506b0ac6a1745"
    sha256 cellar: :any,                 monterey:       "b4c73b82a3010e8c2307fbbf1f1cb82cecdbb417654c2be13f39b113d91ed9bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "945a2668be5d0d4d6a81dbab65a76cf8bd6ba7c12708020623cdee8b4cc24b96"
  end

  # Use `llvm@15` to work around build failure with Clang 16 described in
  # https://github.com/rust-lang/rust-bindgen/issues/2312.
  # TODO: Switch back to `uses_from_macos "llvm" => :build` when `bindgen` is
  # updated to 0.62.0 or newer. There is a check in the `install` method.
  depends_on "llvm@15" => :build # for libclang
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

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

    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    system "cargo", "install", "--features", "oniguruma", *std_cargo_args
    man1.install "man/teip.1"
    zsh_completion.install "completion/zsh/_teip"
    fish_completion.install "completion/fish/teip.fish"
    bash_completion.install "completion/bash/teip"
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    ENV["TEIP_HIGHLIGHT"] = "<{}>"
    assert_match "<1>23", pipe_output("#{bin}/teip -c 1", "123", 0)

    [
      Formula["oniguruma"].opt_lib/shared_library("libonig"),
    ].each do |library|
      assert check_binary_linkage(bin/"teip", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
