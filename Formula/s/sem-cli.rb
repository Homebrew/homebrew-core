class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "0a48605c980c47db3625b8e80ac7ff3f7fda57418370ebbdd846e0b8d3457330"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "122fe23d3d50b814543bcc88b7f9778b48b8d72544222b17b539a5ac0d7c995f"
    sha256 cellar: :any, arm64_tahoe:       "a03ee624bdaec01d8b209b329ad66b379751c288b5452e70f6dc5222a16bbfa4"
    sha256 cellar: :any, arm64_sequoia:     "0566c448b4e88fe0679b5d341b678d221f0d3857ab7baef1286a111425254739"
    sha256 cellar: :any, arm64_linux:       "1b2d0b2a72d9a6bb6d5bb5bf82022823d06308b79e8aabdfb20ab13b861b2fc3"
    sha256 cellar: :any, x86_64_linux:      "cf0c45388f3b0a5516afaad968d7c7719afecc3f488f25087596989f9ccc83bb"
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
