class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.26.tar.gz"
  sha256 "5ce4c78444431ed0bef30778f9dd74b4be6251497a44afd841449f5e9d6d29bc"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02ef123acd3b31f1c15e9fdbf30e7f7d6ee15c29d838298d1acd3c2d9e378f0a"
    sha256 cellar: :any,                 arm64_sequoia: "f856f17b9d0557562a97bfd6e977911006dd1a738bb7a8fa9e5622b72c4998e8"
    sha256 cellar: :any,                 arm64_sonoma:  "5fd3e5b6f8e25cab1138fda1e387030550e576c84b3cadad815e818a870a869a"
    sha256 cellar: :any,                 sonoma:        "aacb945c7a5cadba0e3a5a5b65e5e555a41b2e5308448b7f66feeee17ae17cbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d70e5c21ce022bfc68fbbffefcf6c26c30173017ea82405144429a4c6bc69d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d71e8c02a03cafa6623a968b6109e1321914410f18e4d225185d44643030016d"
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
