class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "02a4a9e52951300843d4fd9dcd48589d571f08268e1fd14f3e9e848dacf7321f"
  license any_of: ["MIT", "Apache-2.0"]
  revision 1
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "16c9fad57e8f075d16b6369cbb50835088c4cb39080305a951c6f473f13b5ad2"
    sha256 cellar: :any, arm64_tahoe:       "1a4c983859266dccbceef247ebdb1d8db45723a6b0020b55b384bcf1afd04314"
    sha256 cellar: :any, arm64_sequoia:     "cfd4094835c837598ea71f0514aec532675a654ba359bb2a02969d7a165d1d92"
    sha256 cellar: :any, arm64_linux:       "f9906582cc8d35184a975b06fffed5369435abde12b7fd305e38dc5de463513d"
    sha256 cellar: :any, x86_64_linux:      "f7366739a79dafa2786dda40a4177214d381f04249fe9d50e50617f2c90af82a"
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
