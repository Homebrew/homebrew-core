class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.20.tar.gz"
  sha256 "5b990524d85c255aa39341d16f1e5609a47a40dca164c8684b8bc7b2ad4c2ec2"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07019c76d1765c087b33d7c42316443da36fbf33c9e599a68344186cf6bebd56"
    sha256 cellar: :any,                 arm64_sequoia: "3698337c24f69946eb93abdf46ab979a62b7583c0bd12b58faea676804986cd8"
    sha256 cellar: :any,                 arm64_sonoma:  "77a8ae4f6af4a5f0210928bf1742d8ff177a2423cfe142bdcdbdc7ea0a194d88"
    sha256 cellar: :any,                 sonoma:        "7f1a5814a01c460f52a35351de4c46ce369f662df8b2cce7244785ec80ad88d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "509fda2ba7ae9346da21ac748daab80c4a9f984c9753c60e1b4d5050b25288bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a21a401d0635d660a43da12f328cf921866d4e384aed7c7e38bb8d544fbc5dca"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/yozf --version")

    output = shell_output("#{bin}/yozf config get a 2>&1", 1)
    assert_match "Error: There is no 'a' property in the config file", output

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"yozf", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
