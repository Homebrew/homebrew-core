class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://ataraxy-labs.github.io/weave/"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "e5a2da626bb329b7ad38cbd206dc9cf67e30be719e84900d45415d448da76af7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d763a24fefa8d0c73780806439099cbaafcb1263659d7d3fafaca909b8f1c16f"
    sha256 cellar: :any, arm64_tahoe:       "7ad89619320fa3faa0783c9bb3cf085f5bce8d9c526ceed1e11d2207763f3654"
    sha256 cellar: :any, arm64_sequoia:     "64d4c4c5a50ea28d61ea94c8c587cad825580bcafc7854566127d71058cd8512"
    sha256 cellar: :any, arm64_sonoma:      "bd7c7a78eb87fc5f29cd816ccaad06ee5940c7554c1d8a48384eacbce5724ae9"
    sha256 cellar: :any, arm64_linux:       "cc97bef0c42d906b1870f7f7a240d55a5466eab9f3697a40ca299dd29ec42187"
    sha256 cellar: :any, x86_64_linux:      "8f8a177158423d782e8cdf6e156434fbb69a99064efe23dc125c03e9eee2194a"
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
