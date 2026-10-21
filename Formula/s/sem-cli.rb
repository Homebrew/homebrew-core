class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "b96e62f2c571ec8f6265ba7898054ebb77c99a7d8b2d871a41fee286e1cd6cf6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "18b551b20a18c1e163a76dafc058ab18f993100b5ddb5cd7a88818c9ae154b3d"
    sha256 cellar: :any, arm64_tahoe:       "9cf8b4bd2223895e928f8d0c7cecb82f3bc029d78274b84e6ad17ce4a8889a23"
    sha256 cellar: :any, arm64_sequoia:     "fd4b009493b7886813901e1cd683ae0eb6dbc33ab5fb4551134aa8760bb82f4c"
    sha256 cellar: :any, arm64_linux:       "bfe45bc992ee4fc784195bc8ed584a634c3dfc1d9910a551eedb2438b84f3934"
    sha256 cellar: :any, x86_64_linux:      "6b89e6afe720838e24813bac195ba7e31d2d0b1612a5775873602a696f3913be"
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
