class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "4b6ecfc6c1a94c11d1c20f0f19ed5f64c338bf8908137ca6546ad82c10732089"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "86eb715d5c6c424f15ec6a1bd91448389e7fa9891ae322b2e91f4b907a1bc424"
    sha256 cellar: :any, arm64_tahoe:       "fa812d5cc434fc5f287389bede3dd4d7759eac97ee3923ea000a81357fbe30db"
    sha256 cellar: :any, arm64_sequoia:     "564d2f7ee81cb63bdbd707b97dc51f1ec7b53cc99e4467613af3acbbc578f164"
    sha256 cellar: :any, arm64_linux:       "53e402e20bea1b451dfa2121fa90c39631dcc8bec4179b26fa86a1ecf55fcba7"
    sha256 cellar: :any, x86_64_linux:      "564f0bbabae791a95644da72fc592a9b2374212bedfa3612039df09cb939bb83"
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
