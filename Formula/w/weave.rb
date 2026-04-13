class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://github.com/Ataraxy-Labs/weave"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "531a290b42d9cef867bbceaccda43341fc6c4eecdf0f4d5c1dcf99bbe121c32e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "93dca44743ca548d017963638dcc0a6230ccf54cca7c6278c548b4f446da5662"
    sha256 cellar: :any,                 arm64_sequoia: "e736982f3998bd6575523225652d9d7ed25dfcacfd3650f0430bca0f42f38fce"
    sha256 cellar: :any,                 arm64_sonoma:  "fb573178d4ba3b5d1087e9ffaec3cd5d723f9fa211b3f0ddb54e40a8dc95ee4b"
    sha256 cellar: :any,                 sonoma:        "10a35063bbb442e39ad4fa8eb15895589874fc9150557e4261922ad595730298"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eac5e3e2297a57090db6b1b1fda0887ab2d7f08b94aa0b375c34f67bfef52531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd7add9cee90475aaaf76f0321ec90b6837cd3c5769939c05f94f71e7f6a0709"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/weave-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/weave-driver")
  end

  test do
    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")

      def farewell():
          print("bye")
    PYTHON
    system "git", "init", testpath
    system "git", "-C", testpath, "add", "."
    system "git", "-C", testpath, "commit", "-m", "init"

    output = shell_output("#{bin}/weave setup 2>&1")
    assert_match "weave", output.downcase
  end
end
