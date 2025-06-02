class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v22.8.1.tar.gz"
  sha256 "0c92d8afcf3f888b09610b744cf1b28c4578aecdc1c32d2a397286d9a72bc2d5"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "501610d1a9b3eecde77e439ff1d5445182b5a7167b688ab2d35ec98c1f79081e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "050a2e478db547437238318742d6dda25265c08e03be8a3acb8b9b4a0dbfa2bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5b2439f176e56123c335ecf6419593adb1ec0e7d42e801af579595bfb3d9103"
    sha256 cellar: :any_skip_relocation, sonoma:        "3db6c61043d74f24fd6bfc092fe9dc3897a31532230e8c9a67a38dec673700ab"
    sha256 cellar: :any_skip_relocation, ventura:       "070680b7cdac82e3644907f00fd8a91a0fbefa99f7ac57278ad3c279e3baf896"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c2edc0de9592016af29f6b1d09ed6e535c6d1922ee19dd53004000ef9c34558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "495ff1bc15baa7f050775ae0f97d0c3993aac08ad3cc2ae98ec7660bd52a520e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", "--bin=stellar", "--features=opt", *std_cargo_args(path: "cmd/stellar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}/stellar xdr types list")
  end
end
