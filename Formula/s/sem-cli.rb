class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "5384646ee2aa5181bcd3950c322d9cedd59f49a4a72053d31cc484f0bd9d196e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b581e6b179657b97c118ae981ce8a9e7fa41345bd5817ebe779332c89a95d123"
    sha256 cellar: :any, arm64_sequoia: "8d617f9ec0d5b4f9db80a46cd90240720e85108a2752a040b48a31298507bdc6"
    sha256 cellar: :any, arm64_sonoma:  "d4a918306b755bb37eb5c7374b641e00e2470cb8d1bfe28c3247a83a2e84d5ce"
    sha256 cellar: :any, sonoma:        "35d997b256705c798d113713f98f0f34d037c5d6dd88349c67010e7cf6873cfe"
    sha256 cellar: :any, arm64_linux:   "e746e215af4409f02289fc7bbccb5d72a0129dae5c345eb0031beb618f771b9b"
    sha256 cellar: :any, x86_64_linux:  "2a8921254ccab785998eeb454185ca01989919656551885932613a93b52075cf"
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
