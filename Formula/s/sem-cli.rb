class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "97fcceab5745204001526220f6e207925466e49489d3af4cc76b9219a59b5a97"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cfa4678f06b271fef2e00f840d2d3420d98c46a0bfb2b9d047403e3810540df8"
    sha256 cellar: :any,                 arm64_sequoia: "7a6639a4334eca568c3bbfd1de9e428d90021b5d0a54eccaad402762583ba4bd"
    sha256 cellar: :any,                 arm64_sonoma:  "f991d6d06701f6d226c938b99c679111880fcdfd1e1f0265ea4355b4acd36ed2"
    sha256 cellar: :any,                 sonoma:        "f26b9f883276274dcecee0bfd972bb8082b4a14afa948eaf27cade53d89b93ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5af4ed87b7b156aaa7f14c4879f0c74e76d537ba3667f00ed641022332dbecf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd165cdb0bcf904db75bd905d9a8f0aca3ecad985bc7a2d344ab1c3e7777cff9"
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
