class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://ataraxy-labs.github.io/weave/"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "f28df8d0ef3d3ab3d8d614d27e6cbb930519350b93ebc6af7232a28547698b51"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ee475dc1f4b49e80f702519f7e4f7e1e4d30727a448a05833dc3a9e4a2328720"
    sha256 cellar: :any, arm64_sequoia: "de3a0381fc20e4aae743642a5c1f03162dfc05c8921efbfb0a594057c5c072eb"
    sha256 cellar: :any, arm64_sonoma:  "222c6066333a7999c6bbdeb0931b7cd1d7197c50cf239cf459b12313e38e2ad1"
    sha256 cellar: :any, sonoma:        "3f4ebfdbe4ea04e88b05cc2181d49aacefb25ed314f28b2ba8fa788fa120d45a"
    sha256 cellar: :any, arm64_linux:   "81f893f6d8ca41f8dc0ee8c51a260387c6e37031abfadc48729008824988c003"
    sha256 cellar: :any, x86_64_linux:  "d3cae05f1f8dc153676e8fc76f17f71a420e819344511441de0125a856ecc805"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "texlive", because: "both install a `weave` binary"

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
