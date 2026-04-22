class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.23.tar.gz"
  sha256 "988c465c1b13ba6d7d47194d41aa7f33f38bf7fee110fe6b3a76d7314d6b8625"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74f40b8091158e6826517df1c392c48eedd2f77b6dae967d975672267510938e"
    sha256 cellar: :any,                 arm64_sequoia: "f5c49909e99d5c343c7c3b4f6a8dca0761ad53ea45cf87d2d13bdce7d58d7543"
    sha256 cellar: :any,                 arm64_sonoma:  "6f6bc59c5df4742ce9837f1e6c0c8b00183266c640f98bb5dd5e5a4c68273eae"
    sha256 cellar: :any,                 sonoma:        "7f4c86fa6790575075303cbfedf4afbb93c0177a624b3e65d9ed399137f719eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c74a181023f29569ebe425c6c497c91f67ce7cc91791c0d12c8ac3bc830da3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3b05edb917f73b6fdc252613e6e1ea8176ddd59c3c76a2d945f1ea9828e7e6e"
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
