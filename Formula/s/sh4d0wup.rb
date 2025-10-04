class Sh4d0wup < Formula
  desc "Signing-key abuse and update exploitation framework"
  homepage "https://github.com/kpcyrd/sh4d0wup"
  url "https://github.com/kpcyrd/sh4d0wup/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "cfc1c38f89d35de6a1822469679a73e5bcb7d5b9f6f8519bee1c3f2948c227f3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "099af7350fa6b8abe3e0cdede86d930f195e06484082345a511ca64eea219b40"
    sha256 cellar: :any,                 arm64_sequoia: "61e657e991b147d09961e7a31cb8519a0a7d5da5c7549381cc093e6c0f09b865"
    sha256 cellar: :any,                 arm64_sonoma:  "c6a718415c847755a24e462bdbfcbbfbad1c0c4c5d5346917121bb7b2b817192"
    sha256 cellar: :any,                 arm64_ventura: "4ad860189d7456e964cb5bf9ca83d58fa42826749fe687f3b7a188df76a84cec"
    sha256 cellar: :any,                 sonoma:        "5f916dd0b4809e160f6d44f5536d4eec43f75d4dade3b3023dc0667062b73254"
    sha256 cellar: :any,                 ventura:       "88c8352a703fe178771071b45781127a76a84476104afc1ef1f7042dd0ce9ac4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37e09448fc27e25b451c296e0849affe15ee491ebbbaf080756818da61bb6085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12ed1c91190821ba799e038cb7723ce0af1ef207b45b74fcc732e8adb233d017"
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
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"sh4d0wup", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
