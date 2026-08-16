class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "a9e44aac01e223c915a8e3a3b3c7d982b1d43d1c6d88cb6030a86899494c3377"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "548090461884e2e9aca43bd9c8ade0817770d0a16b521ab23371ea9b5ffe0bda"
    sha256 cellar: :any, arm64_sequoia: "53231426f4eb8c3a0b7fde3b65158cd8df920e1202b1376a0d2e34eadd00b2a3"
    sha256 cellar: :any, arm64_sonoma:  "d2750a79deca06dfdeed69e70be0351f127747308350f2492109ff38ae31a1a5"
    sha256 cellar: :any, sonoma:        "8ab7d57d249c33665c73a09a7228f2697dbe70c72af6fb38151a927f0e6139cb"
    sha256 cellar: :any, arm64_linux:   "f624cce7d0f1597425531ef460d4ab20d744800017d5dc315b9da1a3ab84b725"
    sha256 cellar: :any, x86_64_linux:  "c5d63837480e3cababfe560e194fabdc2dfaf357c092307fd97825682c240b4b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Bump crate versions the v0.21.1 tag missed so `sem --version` is correct, upstream PR ref, https://github.com/Ataraxy-Labs/sem/pull/480
  patch do
    url "https://github.com/Ataraxy-Labs/sem/commit/0a9b9e25b87c1899b4f845bf53d460077a8bea3a.patch?full_index=1"
    sha256 "bd1d92be66831a60e5c426c18f57f776ccd8ea9105c3d4006b29753630b0d2d8"
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
