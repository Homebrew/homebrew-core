class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://maif.github.io/yozefu/"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.31.tar.gz"
  sha256 "0e0c40c9778a007e49b7eb2475a73e718b3c65b0ea1b02821c691826cc86890f"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "72bf12665a6975799181010917e871c9f26b2e556aa5dcc04415af3ef10914b8"
    sha256 cellar: :any, arm64_sequoia: "023bf8bf5882ff6c9bdc6e1a824c84ad954805cbed9b15d3309340b73b186f28"
    sha256 cellar: :any, arm64_sonoma:  "943a16f737dfc1c3799bd7f91e6f3a3bb853eae5f3aa5edc19db947bd77bd530"
    sha256 cellar: :any, sonoma:        "5ee6eca8b51ffd85ea9d4337a2528fabc51ff646a683dd8c7286bb2dd764146e"
    sha256 cellar: :any, arm64_linux:   "994132efb9fb2a3f1aea33d137e3c9196f64b348df89f0b57694d20ae53fdc9d"
    sha256 cellar: :any, x86_64_linux:  "d9f58ceb6a4007f291261b4004e68f98fa8e0a5025558b1e276a1ebdabb5b033"
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
