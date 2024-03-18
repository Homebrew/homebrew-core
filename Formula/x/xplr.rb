class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/refs/tags/v0.21.7.tar.gz"
  sha256 "d38f94cc46044dac3cfc96d89dec81989b69a66a98c2f960ea3abe44313675a6"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f3666a6f4117fa680ac7424d3c6b3f6cf7a92bf96cf884c1490fd627010c0df1"
    sha256 cellar: :any,                 arm64_ventura:  "c645f6c3d7ff3e6ca29837e7e6b57a5d222f5fe77e2b4094d3c7670fc1342440"
    sha256 cellar: :any,                 arm64_monterey: "d0b55b103b10a774b46448ac996be574b0fc4a530522aab9d122016014ffd7dc"
    sha256 cellar: :any,                 sonoma:         "a1b71054003b61f1fbd94dd58df36745ba0c5a492a4f3dae35ed854682f966a4"
    sha256 cellar: :any,                 ventura:        "99f8987aab4128368ed62b733a35e0f296d1cca3e0f8309cc484ecef9e6010e7"
    sha256 cellar: :any,                 monterey:       "c3025a4aa9607069ba5f7c464a352f8adc9450efcd3f7cfb16112c1e50286bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b76fe0e71bd844dcd6a6943d0841bb77b71480d47948f26ed584d89ff159872e"
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
index 6c50de0..953d578 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -73,7 +73,7 @@ features = ['serde']
 
 [dependencies.mlua]
 version = "0.9.6"
-features = ['luajit', 'vendored', 'serialize', 'send']
+features = ['luajit', 'serialize', 'send']
 
 [dependencies.tui-input]
 version = "0.8.0"
