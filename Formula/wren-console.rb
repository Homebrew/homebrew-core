# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class WrenConsole < Formula
  desc "Improved REPL and CLI tool for running Wren scripts"
  homepage "https://github.com/joshgoebel/wren-console"
  url "https://github.com/joshgoebel/wren-console/archive/v0.2.90.tar.gz"
  sha256 "5af9e6383606fec4429dcce88c6643025a2363c0324906a1661d7f6848e204b8"
  license "MIT"

  depends_on "git" => [:build]

  def install
    on_macos do
      system "git clone https://github.com/joshgoebel/wren-essentials deps/wren-essentials"
      system "make", "-C", "projects/make.mac"
    end
    on_linux do
      system "git clone https://github.com/joshgoebel/wren-essentials deps/wren-essentials"
      system "make", "-C", "projects/make"
    end
    bin.install "bin/wrenc"
    pkgshare.install "example"
  end

  test do
    cp pkgshare/"example/hello.wren", testpath
    assert_equal "Hello, world!\n", shell_output("#{bin}/wrenc hello.wren")
  end
end
