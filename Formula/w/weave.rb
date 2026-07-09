class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://ataraxy-labs.github.io/weave/"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "3795fcc28ada8b522fb0081a1b8f3ace6e4f61d7be46fdb3cf588777b5f0608f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eb079cf08f69a75c497116a47d3819a5f281321484a9c319e440d72871a4b691"
    sha256 cellar: :any, arm64_sequoia: "abf4ba376ddea9c2ffabd2d7d85a76a9d6a28ed67e2ca47377c9bc9c211322a2"
    sha256 cellar: :any, arm64_sonoma:  "939a7a987580f91d21c2f5f8e35cba4a3a3773e6a408a407efd3b692f97ed930"
    sha256 cellar: :any, sonoma:        "4b9143760b2dbd574d05fc61ce794f052e799677a522a470fd96cdb99ecafb24"
    sha256 cellar: :any, arm64_linux:   "885faf28efaef1b93f8eb623b863553b7ddae4fda1b47326dcf78614e3967a81"
    sha256 cellar: :any, x86_64_linux:  "d2da3f1e3a12401c147af121d879eddfce1064d7b8f1fc49d05000b98b75e1c2"
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
