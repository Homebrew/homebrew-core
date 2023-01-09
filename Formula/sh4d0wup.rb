class Sh4d0wup < Formula
  desc "Signing-key abuse and update exploitation framework"
  homepage "https://github.com/kpcyrd/sh4d0wup"
  url "https://github.com/kpcyrd/sh4d0wup/archive/v0.7.1.tar.gz"
  sha256 "08d294033d70a4b4ddfbf41dd74b33200664512b7d228b16cc05b6aadf6a1e74"
  license "GPL-3.0-or-later"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "nettle"
  depends_on "openssl@1.1"
  depends_on "zstd"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sh4d0wup", "completions")
  end

  test do
    system bin/"sh4d0wup", "keygen", "tls"
    system bin/"sh4d0wup", "keygen", "pgp"
    system bin/"sh4d0wup", "keygen", "ssh", "--type=ed25519", "--bits=256"
    system bin/"sh4d0wup", "keygen", "openssl", "--secp256k1"
  end
end
