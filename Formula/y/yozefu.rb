class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.22.tar.gz"
  sha256 "2bb214b27c9870c478a9f1b3e65dd9221f0888d2575d05580e1527c90f2a9a8b"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a648706ef26d88ef909cb63bba24792adfb68ae947f56cb2c007b70183b6a22"
    sha256 cellar: :any,                 arm64_sequoia: "9d9d384f309912fa4f80937235b0d7fe63ad02409731d0e6f9dedbf614caad62"
    sha256 cellar: :any,                 arm64_sonoma:  "2a5e4adc4c486765884f6d5f0c2154ef00d7073b9d1511a174fb33fcf1e18efa"
    sha256 cellar: :any,                 sonoma:        "af8f417fdfbc70b05df4ae6c6b824e9de1a971a19cfdfcdce65539420e9bb5d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65876989c3b535f80532f56aeeceb2c93d470261fe76da3170c60b5910f9b8e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71cf1d199893cfb190189808612ad854516b6d2d3b41312aacf3f1394cc53c29"
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
