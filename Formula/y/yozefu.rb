class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "18f69f35960cc2600a7acbbbba7e5613a3aa3b63dd3ae9600714efc853bfb943"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f36a9a5cc54a539066f3d45909b8ee1fc797883d64d272f8daadc013d8c6c4e0"
    sha256 cellar: :any,                 arm64_sonoma:  "40ed31e180b98575e58de31e17b81a16f6b31f4a256e28f87df4f964d51a58c5"
    sha256 cellar: :any,                 arm64_ventura: "a5ddc196c6949bbe563bfe896eae521f21ad350562c0436fc0d406e2767e2279"
    sha256 cellar: :any,                 sonoma:        "6e0679a11f0e7ed93b6b1ac4836134f887eb1af6b2fb3e4fc629dca1a9a2f37c"
    sha256 cellar: :any,                 ventura:       "92a4cab4d5806b84181f277ab66dcf79c44f3967a04aa551676ddc0475a84567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afc8e34d5ac7994d82228ba43437f90911fb6e4155c4a5d5d1aa574889b64373"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

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
