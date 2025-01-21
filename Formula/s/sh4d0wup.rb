class Sh4d0wup < Formula
  desc "Signing-key abuse and update exploitation framework"
  homepage "https://github.com/kpcyrd/sh4d0wup"
  url "https://github.com/kpcyrd/sh4d0wup/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "63662f386302ceb06470cab62a36924a1a2efcb51602913f8cf6e2a5a2a34acc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6540738f0265efb9e3f511af4b63dc9cbb91a6179c701309a269a3eeaa2f3b0a"
    sha256 cellar: :any,                 arm64_sonoma:  "07bba11a7500ccdfe6359bb0a2e5bc96decd4ea8b53d9d86f8d3844532bb752e"
    sha256 cellar: :any,                 arm64_ventura: "c19a90aee8ec95180f4383d4e4199ef106dbe0140ce50506319cf85acaace739"
    sha256 cellar: :any,                 sonoma:        "be07c857f0b5a7ed98808891806c05d9c2363519207e3180f7bb61ed619f4963"
    sha256 cellar: :any,                 ventura:       "bf9730529911ca723d3422e19653c3458f18566c8484531cf695fd16a7c0b88c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f5737e1328718e96a6f737b7f994099d552d27a74dd3424698d5426fde8a06e"
  end

  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "pgpdump" => :test

  depends_on "gmp"
  depends_on "nettle"
  depends_on "openssl@3"
  depends_on "pcsc-lite"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib if DevelopmentTools.clang_build_version >= 15

    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sh4d0wup", "completions")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    output = shell_output("#{bin}/sh4d0wup keygen tls example.com | openssl x509 -text -noout")
    assert_match("DNS:example.com", output)

    output = shell_output("#{bin}/sh4d0wup keygen pgp | pgpdump")
    assert_match("New: Public Key Packet", output)

    output = shell_output("#{bin}/sh4d0wup keygen ssh --type=ed25519 --bits=256 | ssh-keygen -lf -")
    assert_match("no comment (ED25519)", output)

    output = shell_output("#{bin}/sh4d0wup keygen openssl --secp256k1 | openssl ec -text -noout")
    assert_match("ASN1 OID: secp256k1", output)

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"sh4d0wup", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
