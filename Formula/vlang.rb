class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/0.1.20.tar.gz"
  sha256 "8102b48b2c82be6be14633e76e71e215aab5221198315436f97be53e1abe1f5d"

  resource "vc" do
    url "https://github.com/vlang/vc/archive/0.1.20.tar.gz"
    sha256 "5b4fc1f39c3aef5214a3366e0d514ee2879a2e52a918dc0181df833028a0eb72"
  end
  
  def install
    resource("vc").stage do
      system ENV.cc,"-std=gnu11","-w","-o","v","v.c","-lm"
      libexec.install "v"
    end
    libexec.install "vlib","compiler","examples","thirdparty","tools"
    bin.install_symlink libexec/"v"
  end

  test do
    (testpath/"hello-v.v").write <<~EOS
      fn main() {
        println('Hello, world!')
      }
    EOS
    system "#{bin}/v", "-o", "hello-v", "hello-v.v"
    assert_equal "Hello, world!\n", `./hello-v`

    #need https://github.com/vlang/v/commit/fa7e0ce58a731d393e633b68a0710c7d1e27543f to be released
    #shell_output("#{bin}/v test v")
  end
end
