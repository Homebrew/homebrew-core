class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "844f9bc0520b7c7d0ff0d69e73f9faebf4c90cd187708d1327af8a73f5eb5df8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7005053594b0e69ce78222c7bad879dea1f03607da826c364ca26d57b608aa1d"
    sha256 cellar: :any, arm64_sequoia: "9abb65d3592dfaed8d0006a963f26190cfbb3ca16b9837a2c6343761f15a9023"
    sha256 cellar: :any, arm64_sonoma:  "ef13229a73f292475aebd5f5dc19ce25d986427a0b1e8245498aa9fb7f897769"
    sha256 cellar: :any, sonoma:        "ba1e5acd3b642b0357eda885274865b2581a2b1228ebe1eee90c20017a7f77c6"
    sha256 cellar: :any, arm64_linux:   "68c852312286a3c24e33574d4460240633d7569955e089507a3ab23abee7fc59"
    sha256 cellar: :any, x86_64_linux:  "e63aa25b93cf680ebaca5d0b2bab247773d8e37cf7b615cd328a6b5390de3f27"
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
