class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.24.tar.gz"
  sha256 "6fab3313fb3d8606ca3f9e67497b3da72af15d900748f9d4b21b21285d4934ab"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6340d645529f7345a6a37c6f8944788f97d10f1feff5cc68e043448a27632f3b"
    sha256 cellar: :any,                 arm64_sequoia: "04439418c52ab3af2d02f45ea3cb8a22765ca8f7406a701785d30356a519198e"
    sha256 cellar: :any,                 arm64_sonoma:  "f93dbf6f7bbd181004d85f5cc41bb152842d312b9f9121bd2a1ac8f7ad6ca4ae"
    sha256 cellar: :any,                 sonoma:        "11c10113b3bd1375dbe100eeec6907360120886920f89d5bca03df0f33580a20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0e96a676ec0dec2bc655e85f855a00b5ce4168a611a4ba86025e290c8259a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c4e03d40dbee75c53355a833552061c520c61e00661259fb2135d9507312ca0"
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
