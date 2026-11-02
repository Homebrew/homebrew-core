class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "4b6ecfc6c1a94c11d1c20f0f19ed5f64c338bf8908137ca6546ad82c10732089"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dcff37969cc391dd902fb5445a2f9dc635b4642d915f7b9a4e68a26bab621439"
    sha256 cellar: :any, arm64_tahoe:       "419b82b77c3634fa5eedf03744020068c737e6bf1046d8bf078f488faf396a2b"
    sha256 cellar: :any, arm64_sequoia:     "406bd4519e69e3548b0b4bbe6fd4fec1468fe365d5148dea1338e8db7953cbef"
    sha256 cellar: :any, arm64_linux:       "c20d925e4bbced97bef2d1df6609a541f72c4e221757cf3d7dce01636aec7712"
    sha256 cellar: :any, x86_64_linux:      "ab4c4f01fe191c4a77354780c53a261f94f7df9ae06ae91ac7e2a870e238cbbf"
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
