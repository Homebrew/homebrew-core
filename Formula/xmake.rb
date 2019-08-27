class Xmake < Formula
  desc "A cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.2.8/xmake-v2.2.8.tar.gz"
  sha256 "fb8ad4ca5133ca0cc303e57c24afaf00fbdaf7a9d59e1a6e7c4337803926bf29"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3cb280a164d5fa34450caa401b94eaee5ce8162315a19eb0a874a63b730ac24a" => :mojave
    sha256 "afa7b083385329f2936d15731472dc6051d65e465334164c78a2f4c6ac6a14b6" => :high_sierra
    sha256 "d5159e8d6979900ac5865b3f4fa707d841af1ae5a5478cf460c4c3ca61c0f8c5" => :sierra
  end

  def install
    system "./install", "output"
    pkgshare.install Dir["xmake/*"]
    bin.install "output/share/xmake/xmake"
    bin.env_script_all_files(libexec, :XMAKE_PROGRAM_DIR => pkgshare)
  end

  test do
    system bin/"xmake", "create", "-P", testpath
    system bin/"xmake"
    assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
  end
end
