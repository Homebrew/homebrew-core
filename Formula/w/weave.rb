class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://ataraxy-labs.github.io/weave/"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "2c3c913b1b2ae8c2c90ec152211a5818828714f142436c32df6b21391ad9cc35"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7b7cd79ef266bdc4001addaec5cd5ceb9037f892487589bdba6755a3dd9a7bf1"
    sha256 cellar: :any, arm64_tahoe:       "d6e40d76e8a3cec5a98189e202b051b4c5678b6791f4740f673f7009b4297695"
    sha256 cellar: :any, arm64_sequoia:     "fcfa14f455e319538f42adc09228e5a4a4d72d7811c98d2e578bd227757afbc1"
    sha256 cellar: :any, arm64_linux:       "1ba7fa4b989c38be5320f48adba7186e6843b3181ccfd8ee762cb696c79ec95d"
    sha256 cellar: :any, x86_64_linux:      "642b8a7f4233c2d3de2dcac2a3fd53d6c5749d186b86c36149832d669206f1c1"
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
