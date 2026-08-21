class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://ataraxy-labs.github.io/weave/"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "3574c794451633f8b2e799a714ec85b9e0fa55eabe406dc71d3803ae6d1f85a2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5f6992fd63b6b77cdb4a2a383e38e79eb3237c5b25f2d7d389d59f3c9b91bbd0"
    sha256 cellar: :any, arm64_sequoia: "d2a52fd4dbd90b1e8945bdcdbcc28ad8f5f4abe524fd8cbab112dadf6cdd630d"
    sha256 cellar: :any, arm64_sonoma:  "833ffefd2e8ef68a9eb3f09f97b9171e165ff13117dc777f3323ab85d0f5df7f"
    sha256 cellar: :any, sonoma:        "d02ce4c93e5c3f41cee60869b6df9270270d15b040fd98bb9ab2cd5fd60ac066"
    sha256 cellar: :any, arm64_linux:   "db24311841acba8f7b757edb8c87ba47070381292c134f2a3d476498517f5bc7"
    sha256 cellar: :any, x86_64_linux:  "81717dfdd8dbf091541bf96cd75f4ef972ca66d4774b0d5db57b8b0ce51b85ec"
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
