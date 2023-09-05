class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "27800f0e731aedc194872609263e8c20b2e94b2f2e9088da5d3f501c406e938d"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf45f453db98e46627589ccb714c4dd77784ca3ed66789707c323e205ea032a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "250b160f712305bf0b26a9b646ebb92bdc75b5ec07ae8b02140abece36daadc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c2d4469d1f47267e696d4f585d25c76d9f24e0b43b80154c3574fa5514361a3"
    sha256 cellar: :any_skip_relocation, ventura:        "3208ff8b9db848db3dc018b545f5ad9db80eeeb7f0a4f621b29da07ee8e69dbc"
    sha256 cellar: :any_skip_relocation, monterey:       "26bec132afb8adf781fe4b8f5e453b1e807eed1767023c3f4059aa6683faba19"
    sha256 cellar: :any_skip_relocation, big_sur:        "6492c79136002ecb1d9a604c74c97af1e050b1735f7d2830dc64ca3ac6b12f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55d18fb8642c8eb2a34c15889abb5ca5010fe6ae24b9044a500f5e2384d734e3"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "luajit"

  # Avoid vendoring `luajit`.
  patch :DATA

  def install
    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"xplr"
    input.putc "q"
    input.puts "exit"

    sleep 5
    File.open(testpath/"output.txt", "r:ISO-8859-7") do |f|
      contents = f.read
      assert_match testpath.to_s, contents
    end

    assert check_binary_linkage(bin/"xplr",
                                Formula["luajit"].opt_lib/shared_library("libluajit")),
           "No linkage with libluajit! Cargo is likely using a vendored version."
  end
end

__END__
diff --git a/Cargo.toml b/Cargo.toml
index 48bd3e1..69cdd17 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -73,7 +73,7 @@ features = ['serde']
 
 [dependencies.mlua]
 version = "0.8.9"
-features = ['luajit', 'vendored', 'serialize', 'send']
+features = ['luajit', 'serialize', 'send']
 
 [dependencies.tui-input]
 version = "0.8.0"
