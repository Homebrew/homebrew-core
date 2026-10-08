class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://ataraxy-labs.github.io/weave/"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "e5a2da626bb329b7ad38cbd206dc9cf67e30be719e84900d45415d448da76af7"
  license any_of: ["MIT", "Apache-2.0"]
  revision 1
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6835848907fe9d54edc26f9fbdf7ff0126b7bbc244e000add32d97ec73729847"
    sha256 cellar: :any, arm64_tahoe:       "981e632d3963d9dba2b00259e6ce493c1e996a54eb5c0f5c9f293f10d47cb337"
    sha256 cellar: :any, arm64_sequoia:     "48e66a728df2bfc24c014b6a4c065f5dad0c8213cfa63e5245a037c9b596eeea"
    sha256 cellar: :any, arm64_linux:       "39fd39e73de7247b4b0280cf1f0bfb19448a0d9401f71258234f1f31a64fa96f"
    sha256 cellar: :any, x86_64_linux:      "bb5cd3bc1a777357ccc8a77a82e59422fa589e5c869d75c5a7fcd2ccdaaa1e76"
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
