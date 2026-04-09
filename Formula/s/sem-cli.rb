class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.14.tar.gz"
  sha256 "c8ef922436a9a3227c4ee9c31b8fd2c980b1fc3b9c7bc6f3e62966d05658502d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b66612de071988b58297b9365d421e82afe7e9e51fe6ff6e7dd5b358b336a66b"
    sha256 cellar: :any,                 arm64_sequoia: "d9b83e63c8fc5d7d70c0172f6a5c278ed225aa195b4ff2ae190a1418b972d51b"
    sha256 cellar: :any,                 arm64_sonoma:  "cf040d088059012eac18fb226844b5acf42729f4c3efc1e5478a104ec2956f58"
    sha256 cellar: :any,                 sonoma:        "7c425b2c7250eab628aa4a2dbb27370a1b06760dfc4b64119029375029b0e895"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d177ad672ff3178085e1f3aafe314298de0a6bddcaf38e4e878b49883a343cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67eed23af5f9d335776ad4b8837937687d3aa4ceb8831f139053440ec2634860"
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
