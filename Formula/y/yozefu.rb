class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://maif.github.io/yozefu/"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.32.tar.gz"
  sha256 "ff2b0d57fe8c26a7bf5c957c341e2db3a0c98f1f271085bb8bff2bfb934fcf2f"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "bb9063e143d001351210e40c462f9d9ee30e9372e9ecafcdd8b91d96d76a0247"
    sha256 cellar: :any, arm64_tahoe:       "47f17cfa36c7555cf00f49c4005382e1a3a155dc727a2625251106cbb2b7f925"
    sha256 cellar: :any, arm64_sequoia:     "7de4db2a95f0f618fe83a4afe9589aaea038a160df701eadf8595d7df2e19437"
    sha256 cellar: :any, arm64_sonoma:      "ec2ff63fa9f94d2f11f673d27ad8044af197063d6a730815da4e8388cdccccde"
    sha256 cellar: :any, arm64_linux:       "0e97798f2ba843c5844bde7c2f2f60f58d51624a273ed1d77377618ab3551826"
    sha256 cellar: :any, x86_64_linux:      "b03abe99405ec7e4d86e5dcd2b3fe06e9c9e65353d1e525c13e8375dd1191e15"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/yozf --version")

    output = shell_output("#{bin}/yozf config get a 2>&1", 1)
    assert_match "Error: There is no 'a' property in the config file", output

    [
      formula_opt_lib("openssl@4")/shared_library("libssl"),
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"yozf", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
