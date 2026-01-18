class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.25.tar.gz"
  sha256 "82c3cafd34152527c680780dd0a68c18bf8d00a94696c4a8781e458c1ac43707"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "35f3ea379653f624b52501faa94b9ae05e6cb287ddba55feefdc5bbc7ea861ce"
    sha256 cellar: :any,                 arm64_sequoia: "3862b4501f5b4b401405d18eb34c61aaa07995486ff14a49d66d2725c3cbf0f2"
    sha256 cellar: :any,                 arm64_sonoma:  "c02322ffceb785f43db752f63a9de1d7744d9bc68b7366e8d89b5eb857db6ee0"
    sha256 cellar: :any,                 sonoma:        "4dc38b3acbd8154c90509dbe102738796f9337fa09cbcabe96d67e04316a8249"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccac69a0c5cf12729ac70546aadf4f9d1fda92b1db55d10dbd43d3eef166596c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9590346a8e4de43c564dfba2a2794095842b38b04630bc16154b4ba39f138609"
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
