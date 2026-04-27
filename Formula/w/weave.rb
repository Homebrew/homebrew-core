class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://github.com/Ataraxy-Labs/weave"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "422d7a70a9e547a6f1da49910c8fd091115f230dae2e88cb86c0c1339ff0409c"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c68811551a3b71e248bc343b0e6d700571a2191a55e7266fca0e746de81addb5"
    sha256 cellar: :any,                 arm64_sequoia: "7dfaa548da67527d661b63f8a4dd2d5d1152d9f65197cd8cc25ed806bc2caf9e"
    sha256 cellar: :any,                 arm64_sonoma:  "202b0039a70fbc773458458e094863185bac45fbb7c5e1ad01032da61afdbd1f"
    sha256 cellar: :any,                 sonoma:        "ce5fb89985843b7b31e931762d741362190315dfe77ef2133fb5008334d189be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed8813f6d4c0ec0a822eaafed9a631a98e7b1e6234294d3cf125d95dab2b8ff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22b0a9c1ff66ee81184f468ec798dc9b204fe4ab543e479546f1312f419bdeda"
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
