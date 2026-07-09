class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://maif.github.io/yozefu/"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.30.tar.gz"
  sha256 "9ca0943ed41464e224a6ebc5a289975999fa9c8529438f2bf06ea0b712d2ffb5"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3e402d8851c364c5a49767ea2b66d701e7dec08e9c95334cd6d7933ff411b000"
    sha256 cellar: :any, arm64_sequoia: "0f3f21676e2b30f696615555ce9ee1b822e10d1aa066da36fdcae102ac4e6908"
    sha256 cellar: :any, arm64_sonoma:  "81bfcfc5e76532298bd8aa587bdee9a13c1721b0fbfedbce0c3be50672bc4baa"
    sha256 cellar: :any, sonoma:        "9c3e0c4ed843d7a5b7f11bbb9a0a1e6cea02a3786b1c2c862782f95e9ad1f904"
    sha256 cellar: :any, arm64_linux:   "33577dbc235f79fe3c9e587823c1b540d600056dcf8f4b7118884f9429121175"
    sha256 cellar: :any, x86_64_linux:  "edddb6b4066539f3f1004698250ea8954463bfc8e85ed704519ac62540157165"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/yozf --version")

    output = shell_output("#{bin}/yozf config get a 2>&1", 1)
    assert_match "Error: There is no 'a' property in the config file", output

    [
      formula_opt_lib("openssl@3")/shared_library("libssl"),
      formula_opt_lib("openssl@3")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"yozf", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
