class Sh4d0wup < Formula
  desc "Signing-key abuse and update exploitation framework"
  homepage "https://github.com/kpcyrd/sh4d0wup"
  url "https://github.com/kpcyrd/sh4d0wup/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "92c88eed86e7f6453807db2e5b154859a5952d3ff6be8a2a685879a838f3438f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "572cc7d6702e91fa5f298e1e2e35051f211a6a18e31ea96575b6e7744210fa08"
    sha256 cellar: :any, arm64_sequoia: "fb2ef791853b2121d4a94362d0fc8a2a591e92dd1bc0bd66f3b5a53f1f359e05"
    sha256 cellar: :any, arm64_sonoma:  "31ecc5ad8eb1e9a51301c4ccb991a9191ae131b27505e86a0c83e2bca7728a88"
    sha256 cellar: :any, sonoma:        "d454a2ebb5b997cb3fa3657fcd81e3ee21ae92bc2da12f2027188d052aa19ad6"
    sha256 cellar: :any, arm64_linux:   "29fcbfee357e11addcbd141c0fc826dfd219d35b354c099d1427ae41c9de48d4"
    sha256 cellar: :any, x86_64_linux:  "e3b870856fc7d543a46ae5dab82905b4d5785dda722f4d9cdb0478a1bb26c5ec"
  end

  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "pgpdump" => :test

  depends_on "openssl@3"
  depends_on "pcsc-lite"
  depends_on "xz"
  depends_on "zstd"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sh4d0wup", "completions")
  end

  test do
    require "utils/linkage"

    output = shell_output("#{bin}/sh4d0wup keygen tls example.com | openssl x509 -text -noout")
    assert_match("DNS:example.com", output)

    output = shell_output("#{bin}/sh4d0wup keygen pgp | pgpdump")
    assert_match("New: Public Key Packet", output)

    output = shell_output("#{bin}/sh4d0wup keygen ssh --type=ed25519 --bits=256 | ssh-keygen -lf -")
    assert_match("no comment (ED25519)", output)

    output = shell_output("#{bin}/sh4d0wup keygen openssl --secp256k1 | openssl ec -text -noout")
    assert_match("ASN1 OID: secp256k1", output)

    [
      formula_opt_lib("openssl@3")/shared_library("libssl"),
      formula_opt_lib("openssl@3")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"sh4d0wup", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
