class WrenCli < Formula
  desc "Simple REPL and CLI tool for running Wren scripts"
  homepage "https://github.com/wren-lang/wren-cli"
  url "https://github.com/wren-lang/wren-cli/archive/0.3.0.tar.gz"
  sha256 "a498d2ccb9a723e7163b4530efbaec389cc13e6baaf935e16cbd052a739b7265"

  def install
    system "make", "-C", "projects/make.mac"
    bin.install "bin/wren_cli"
    pkgshare.install "example"
  end

  test do
    cp pkgshare/"example/hello.wren", testpath
    assert_equal "Hello, world!\n", shell_output("#{bin}/wren_cli hello.wren")
  end
end
