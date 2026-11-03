class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://ataraxy-labs.github.io/weave/"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "2c3c913b1b2ae8c2c90ec152211a5818828714f142436c32df6b21391ad9cc35"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ab31b329d303c0cd3ecdfd69539644b39a32c476e9baaa660453a6c4968d4c77"
    sha256 cellar: :any, arm64_tahoe:       "7a38e86ffaceaa31cca3a06d2507ebfd934ce5445486df013ee16e477fe0d99d"
    sha256 cellar: :any, arm64_sequoia:     "8865cec1eb2837e7c44a54aa26e86f5c3904ae49f4df9c7c72e236a106e0a41a"
    sha256 cellar: :any, arm64_linux:       "9cf0c79f432ce0905b2d8e88b8efcbd6edb2088b15852de056dbbe0927973233"
    sha256 cellar: :any, x86_64_linux:      "54301d4cfa3540f501b44be62bfc818913395215e177aaea65c05ddac45d15d5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "texlive", because: "both install a `weave` binary"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/weave-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/weave-driver")
    system "cargo", "install", *std_cargo_args(path: "crates/weave-mcp")
  end

  test do
    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")

      def farewell():
          print("bye")
    PYTHON
    system "git", "init", testpath
    system "git", "-C", testpath, "add", "."
    system "git", "-C", testpath, "commit", "-m", "init"

    output = shell_output("#{bin}/weave setup 2>&1")
    assert_match "weave", output.downcase
  end
end
