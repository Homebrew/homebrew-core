class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.29.tar.gz"
  sha256 "67436dd73795d9b4267b351e3dd454468a05a23b1083f5dc02f1f792c4a4fe17"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9d3d98a3bd26791eb106de15c5bbe82df184380f505614fca87ecbe236e45f1f"
    sha256 cellar: :any,                 arm64_sequoia: "0f40c5d9e96460be9aef60b6b9986c740298419ddc7b116356eb8fc5ac816b87"
    sha256 cellar: :any,                 arm64_sonoma:  "740bafcae31d2cc072a6409dbe584de4091f65671db3b6e5492e4164511fe974"
    sha256 cellar: :any,                 sonoma:        "7d5645505648912410ff5be5a9a4bb4c0def43dcec98ae22f9fac9a9cbc4305b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47397779c59e3030fcb7749a51e21284e9d91f376983e93f7d01f00ded4a759b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f283ca950ae31f984dff568e7c58c0efa262c21ef4f4c980e02d81399289f8de"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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
