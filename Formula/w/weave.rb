class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://github.com/Ataraxy-Labs/weave"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "fb839fffb61588f40d0a83875371b9326b92ede6efb9c3c61adcc74e21891d3a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "91f9054fda3d7da73aea7968e154184cc4e46d4af28d47780731cfe84346d4d7"
    sha256 cellar: :any,                 arm64_sequoia: "2d735657bdbc3124ffed86c5a7d2ba7d62cf8ac78c83b9cd020f6917aaa0863f"
    sha256 cellar: :any,                 arm64_sonoma:  "25c14a52797709415bfc8281e3c85747b0c54d01dd807c7070808ddc82c9069a"
    sha256 cellar: :any,                 sonoma:        "2e75157f4cca649bff41bd8a9d10368ba06e178539a1f924d27fc325d9b41704"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6b6b616b27f9a241fca31687da6c576aed12c80b30a0ae14956b238d31e4a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25a05e2bcaf97bebc2ac9687ea827a11e75c4cbde3aa866f80a5f882415e19a4"
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
