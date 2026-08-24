class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "5c890d52947d95b73178ead5341eadb585d6fdc2ef9795fbe010d5a7d477f77e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8ec125de6d81a7c79f4b4b1002fe67802d3c87b9e4a24454267ec63cb7a591a7"
    sha256 cellar: :any, arm64_sequoia: "b3403910184d75b7b95282e00a57daf09bd210d8528a8435d616117b7fe1faf6"
    sha256 cellar: :any, arm64_sonoma:  "7983490928e0d1b38f325945a895fe534e42406aa072c75b607ead8a0476d32c"
    sha256 cellar: :any, sonoma:        "db5e816b028ad42e8982dcd5dd2fdd4245e7537f172a88a30a33e0d1fd084f11"
    sha256 cellar: :any, arm64_linux:   "d76730efa3ea3978a4782cffaa17e10f7bc8135ab6ae201f2657ebbe5c084a2c"
    sha256 cellar: :any, x86_64_linux:  "e9cb29406357396354d9a7f875b78449d80585a247f32ea400c33c3133a372e3"
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
