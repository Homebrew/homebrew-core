class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "a9e44aac01e223c915a8e3a3b3c7d982b1d43d1c6d88cb6030a86899494c3377"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "da48e47cd49d0b225f91883698ebb836a2155a64346c5d91df55f077b1c99b03"
    sha256 cellar: :any, arm64_sequoia: "01cba5be5abf8075aa0d3a3ee41f682695d71b74db0643e5e356ffda8235c433"
    sha256 cellar: :any, arm64_sonoma:  "644ee6ce740cbcc479b55abdff4fb7985591c4f3bc16fd14fcb8b660aeae2122"
    sha256 cellar: :any, sonoma:        "015669c258b110b4c0835f0f4f124ec1a44488d92c1a259a702de89986dbc2f1"
    sha256 cellar: :any, arm64_linux:   "ad4188bbb122cfc32b8fda919b985085456cd063b9c93a4b287b75af93924e27"
    sha256 cellar: :any, x86_64_linux:  "27d1c241ebcaddd7de7f5efa6cd39a6106b068a0b70d8511647f8f25a7ddb168"
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
