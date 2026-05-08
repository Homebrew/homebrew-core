class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "b906e582e02a29ca569adb68f2a104f154c9518b6787f4261e0904505c0f42fc"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "132894930c7f3fda77333d286582235198b0fc29e3dfd586578d2fbe17208f5c"
    sha256 cellar: :any,                 arm64_sequoia: "359272968f7f795e6e314dc8ecc395e8965891dc00d3810be2d37b9a426f1aa6"
    sha256 cellar: :any,                 arm64_sonoma:  "06fb7123dde33537074d95dd2b5cb248ef7965ec35447a38671b2dec948a429c"
    sha256 cellar: :any,                 sonoma:        "66bedead24b457d5d851c51f9c83ffb002c6eb1d1883e361ec9547eb200884ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "960e1c5a8de3f5153ebd2beda2171c1f167f5575f5debe3799f6ff9a6ca09d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ed60035831a9b9125fa5ccfd9ec95529fcd055b0c06fd486c58cb972f6a4e18"
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
