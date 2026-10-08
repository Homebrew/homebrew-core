class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "02a4a9e52951300843d4fd9dcd48589d571f08268e1fd14f3e9e848dacf7321f"
  license any_of: ["MIT", "Apache-2.0"]
  revision 1
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a693f8363ab044273347ae25e305cf881e8ad4b82ccce29c536cfa46dbafc175"
    sha256 cellar: :any, arm64_tahoe:       "e14183751d730720455e6e339f81fc025e0530f8a44b02cbe45cacb6adf15efa"
    sha256 cellar: :any, arm64_sequoia:     "db58c96c796e7b46fc5c0e062d4e8a672fbd4b8cea29bf4b2f7ffc89b107256c"
    sha256 cellar: :any, arm64_linux:       "88e97c6950d00934f1c261c172a237f7c7fb6dd67936509a2572a67e0c7a66fc"
    sha256 cellar: :any, x86_64_linux:      "b026da0eb8b754d37c53d5720f627ccb8a977073cfb981c44f9accca19f3d616"
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
