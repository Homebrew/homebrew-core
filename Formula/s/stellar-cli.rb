class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v26.0.0.tar.gz"
  sha256 "63ca6d4de21acca8ac20f09bf257530ab460ebc94eecf57b4712ec755f06cfe6"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "108b55aac2975348578092e0d9820f4d121f08b959204113733aa0c00a79aa06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57210c990ec230e7f70165da791a064e803f4a77d889d9f1a6c03e1de71adb4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16bca04794c4790951c91d5ef5738f4cf02202044c9a705ca7ec4d54322b675a"
    sha256 cellar: :any_skip_relocation, sonoma:        "47f06d0091a1ddc03f418e2926b94c8e25e7c7c2197bfc56fab8ed5b4e5240ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dfe1ebdc1d1b068ccb29f9e6880346b5e57705e6691c0666b085ae383d73ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a8ffb5c5cfc72365da35b295a215ed67a05e087bc0f506ba8e611f9c976ea8a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", "--bin=stellar", *std_cargo_args(path: "cmd/stellar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}/stellar xdr types list")
  end
end
