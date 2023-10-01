class Sh4d0wup < Formula
  desc "Signing-key abuse and update exploitation framework"
  homepage "https://github.com/kpcyrd/sh4d0wup"
  url "https://github.com/kpcyrd/sh4d0wup/archive/v0.9.1.tar.gz"
  sha256 "5f74ad2cfc4babf0a718003e9940892250715f413efa321e0c53aedaed568f65"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "13ff5c3264c8f0f0aa7346187878c106cf0cfdeb22a71073bfe9f079a1d34b5b"
    sha256 cellar: :any,                 arm64_monterey: "ead75ff629bb3cb07de41b95217f339197ae801d30c01ba15b5e62f20a3043e0"
    sha256 cellar: :any,                 arm64_big_sur:  "2f5a4688a8812b7ba813e5e1cd6dbf78047aa343b9f6cf45fe56eef2035a8402"
    sha256 cellar: :any,                 ventura:        "faeb7450ab29de66331ad4959b09db604d48655431e190a32f90dd0eb4a7e563"
    sha256 cellar: :any,                 monterey:       "93750a112ed06d0cdf94e57ae34a252bf328af8e51263e3ae5ecd6232ff32dc0"
    sha256 cellar: :any,                 big_sur:        "df3e6dc8f5fdbc83c8da9a7acc11b59b21db5bfadc6d82b5413c2a787c20951b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6ce00ce216375ef4eef7f499ff6d0ea0639923dd3e46df43d5e661c86e2ac80"
  end

  depends_on "llvm" => :build # for libclang
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "pgpdump" => :test
  depends_on "nettle"
  depends_on "openssl@3"
  depends_on "pcsc-lite"
  depends_on "zstd"

  def install
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
