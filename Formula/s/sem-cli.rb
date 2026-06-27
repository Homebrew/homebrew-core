class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "5f107af0826bf120d25df3b3819f5a1629a7a82e78d53dd24e264d0072c5a9d3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "860b1f388cda31a30e228f3f3483dd90a8703f12404f44f1dbba891ea74278bc"
    sha256 cellar: :any, arm64_sequoia: "76c13deee25bb356c26e35a1a399b37d5ce64acf519b5b6efcd545c9cff09838"
    sha256 cellar: :any, arm64_sonoma:  "d292cba9ca09dedb830646dc8e3c0d5432489d9bbcebdbebd11fba3fe49c736d"
    sha256 cellar: :any, sonoma:        "db7dddfd4e63b0e66dd7c4a36fe7cdc924f4a3a03b5fc6fa40ed1a1274271069"
    sha256 cellar: :any, arm64_linux:   "24c74dc44411c95a64de1e5ab5d097f59ace384a28ef1976f7c10d2de5271943"
    sha256 cellar: :any, x86_64_linux:  "b9ab8cbb4e38b1542658dc29ea610b906a23b958ff39df566f907870f8aec93d"
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
    system "git", "init"
    system "git", "add", "hello.py"
    system "git", "commit", "-m", "init"

    inreplace "hello.py", "hello", "hello world"
    system "git", "add", "hello.py"
    system "git", "commit", "-m", "update"

    output = shell_output("#{bin}/sem diff --commit HEAD --format json")
    json = JSON.parse(output)
    assert_equal 1, json["changes"].length
    assert_equal "function", json["changes"][0]["entityType"]
    assert_equal "greet", json["changes"][0]["entityName"]
  end
end
