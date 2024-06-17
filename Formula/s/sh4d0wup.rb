class Sh4d0wup < Formula
  desc "Signing-key abuse and update exploitation framework"
  homepage "https://github.com/kpcyrd/sh4d0wup"
  url "https://github.com/kpcyrd/sh4d0wup/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "7a1258a5dfc48c54cea1092adddb6bcfb1fcf19c7272c0a6a9e1d2d7daee6e12"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6400ac5b11c6bd5e7a057940a73a05824cbe3546ca57f7760f66862975d4dffe"
    sha256 cellar: :any,                 arm64_ventura:  "9b734ee54116c4288b832c79d3e722c057570e39129ba54163242a74bc0a089d"
    sha256 cellar: :any,                 arm64_monterey: "3ab07c4272e04dd6625f1c5071f903e3f98334e0055adbb32170df5ae307c565"
    sha256 cellar: :any,                 sonoma:         "cbb5c0144089d7ade097def6c84e0787a4df4ab567fa9fb4e63ace6e98d6af4d"
    sha256 cellar: :any,                 ventura:        "6d5f820f18c6fd2c8aace97b28279b6ee73c2a972d62b1a9457beff582b52acb"
    sha256 cellar: :any,                 monterey:       "0d0abae2ec6ca3d4db3920e3d6b9263100a3092abaea545daefca656d1ef29c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35560cb4308848c78775629660947cb2a49dc473fc605797ea0132458ec058ee"
  end

  depends_on "llvm" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "pgpdump" => :test
  depends_on "nettle"
  depends_on "openssl@3"
  depends_on "pcsc-lite"
  depends_on "zstd"

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
