class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "97bbd5333f13131d9f2f34d9b41b725ec1e4b611688cea8af4a6ca1ec4dcfc59"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f76436ec1eddde1a7e64d4feb52062e73d8188a89c661704fae23d487f5b91c9"
    sha256 cellar: :any,                 arm64_sequoia: "5ea454e0688f12861712f90c909adeda5e93450fd14a3613361150c4f80c8d68"
    sha256 cellar: :any,                 arm64_sonoma:  "65600ebc2f26b2b534f65206d7f025e31069cbee898a5fff6966d06132c4987b"
    sha256 cellar: :any,                 sonoma:        "c293f58d0ee23d644e01691b93b2a95bc6ff7931b4df8691593cee240e3c5532"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9dad412a5094d005f7bc721ae221699b546b80a5b22c371c6fcfb306490660f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b1fbd41d8141b51125b04016bc98c7cfdf8b2b1fb96bf72db92ff1c22253928"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sem-cli")
  end

  test do
    assert_match "sem #{version}", shell_output("#{bin}/sem --version")

    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")
    PYTHON
    system "git", "init", testpath
    system "git", "-C", testpath, "add", "hello.py"
    system "git", "-C", testpath, "commit", "-m", "init"

    inreplace "hello.py", "hello", "hello world"
    system "git", "-C", testpath, "add", "hello.py"
    system "git", "-C", testpath, "commit", "-m", "update"

    output = shell_output("#{bin}/sem diff --commit HEAD --format json")
    json = JSON.parse(output)
    assert_equal 1, json["changes"].length
    assert_equal "function", json["changes"][0]["entityType"]
    assert_equal "greet", json["changes"][0]["entityName"]
  end
end
