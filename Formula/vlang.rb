class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/0.1.24.tar.gz"
  sha256 "77ed24bf1c3c4eba057ace13bf0fff6fef6d9cdb3c2970f52b4be4582a148e2e"

  resource "vc" do
    url "https://github.com/vlang/vc/archive/b9ea14b1f384b584b146ee59a8b179a1e2d68299.tar.gz"
    sha256 "e17e4ca81c365a25212e0879c02eaad5ee5dd86cb416444d998ea2061c35250a"
  end

  def install
    resource("vc").stage do
      system ENV.cc, "-std=gnu11", "-w", "-o", "v", "v.c", "-lm"
      libexec.install "v"
    end
    libexec.install "thirdparty", "tools", "vlib"
    bin.install_symlink libexec/"v" => "v"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/hello_world.v", testpath
    system "#{bin}/v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output("./test").chomp
  end
end
