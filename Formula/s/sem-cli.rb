class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "6222e5f74b6694c16154f2585b8bd9964010befabf1ee916d55af8a459b31dfe"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "62651cbb4bdfabfa1c6cfb56f960b320147c526b8aeba15ac34e7613b4715ca6"
    sha256 cellar: :any, arm64_tahoe:       "6aae75a425c7620dd5e65bb9d7aef5b2dffd5705535d4387a0ceb207cfcc050c"
    sha256 cellar: :any, arm64_sequoia:     "008e20fc9b4e30613b67a8cd0d9625a149c725e5560e9d660f5a56b5bb148886"
    sha256 cellar: :any, arm64_linux:       "d9832f16d0c8e49acff67643fad7cc341c2e8440b8a9e6ae567455e0bde76f6b"
    sha256 cellar: :any, x86_64_linux:      "0408dff5b8913a2b929a382e40a52b6730f2f0e9ca5f901e80d23287a110ad35"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "crates/sem-cli/Cargo.toml"
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
