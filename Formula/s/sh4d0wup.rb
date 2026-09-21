class Sh4d0wup < Formula
  desc "Signing-key abuse and update exploitation framework"
  homepage "https://github.com/kpcyrd/sh4d0wup"
  url "https://github.com/kpcyrd/sh4d0wup/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "92c88eed86e7f6453807db2e5b154859a5952d3ff6be8a2a685879a838f3438f"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "9335eed1619e8bbd08e27e73b5e147a83760090470daa834fca0a6d226537e35"
    sha256 cellar: :any, arm64_tahoe:       "a6279e7eeb190a0a04ab8a9f90a101f84438c54e6c6cd61ed39d40edb6caf236"
    sha256 cellar: :any, arm64_sequoia:     "314a2bc7d776e0cf034a665cec3f9036b2a3fd24812c9e96f2444a2fdd1deede"
    sha256 cellar: :any, arm64_sonoma:      "a9080458a5d207b84902f2b5bd29b30907536a2e09f3d58a7544c56e2116d498"
    sha256 cellar: :any, arm64_linux:       "fbe8a62b11f71851f3a5fa620c7c1691aafd9d3bce41414475fc648c3de8f4e0"
    sha256 cellar: :any, x86_64_linux:      "5a7deebaadb04cd1e385afe305a7d366a71e4cb8dc2fe9be5de3a6daae38e45e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "pgpdump" => :test

  depends_on "openssl@4"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "llvm" => :build
  uses_from_macos "pcsc-lite"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

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
      formula_opt_lib("openssl@4")/shared_library("libssl"),
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"sh4d0wup", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
