class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "7f619621e4072ae1457128f948dff72e5ebca8852defa8e0f97ee516303c1729"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "761870e175ebace2c9e02763eae3cc191c10a5519c5128646a7f293a3e583be7"
    sha256 cellar: :any, arm64_tahoe:       "4427c85f24e5dd2f819a0d160d55f48e1418909db8e66ff8459f393a7e4749d7"
    sha256 cellar: :any, arm64_sequoia:     "d74ea20068bcf8cab8f2023948878f4dcd2e9969bcae00b74b5b7e8771db5ead"
    sha256 cellar: :any, arm64_linux:       "af790aa870314559435c26ff5b375fffb9829e343bb55e57a3514502877ecd63"
    sha256 cellar: :any, x86_64_linux:      "7e4e8287d89776dccdb5f75eec9b20073e1c98f5b075a626c1dda2ce3b90f722"
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
