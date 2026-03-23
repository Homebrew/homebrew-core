class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://github.com/Ataraxy-Labs/weave"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "06f393f56b3899237cdb461ccb55e0eacedbf35d094de0afc485ac66aca15142"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "904ec617997b7c4838a984435dbfdf8578105599143bb431a3a8e58aeadf452f"
    sha256 cellar: :any,                 arm64_sequoia: "b759fbf55b29d2d611b51b4810a79ff4865bfff19dace1a5c33da3e773b80a2f"
    sha256 cellar: :any,                 arm64_sonoma:  "d1238604202329de0a629ec62c2ebeea116f91676a72f6615fe2659331d657be"
    sha256 cellar: :any,                 sonoma:        "467b7061ff995d5871d558c6613d023f982ea2a170429852db84eb73ef5963f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "523a718f0dda2edaf9d550d54a7fb0ded125400e3bd3fc2b38dfdb6b7c05a14b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdc572eaa49b8fa1db2110f008f88a74e971ff27371e7c1db9c9c530f1b6a230"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
