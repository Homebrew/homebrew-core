class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.3.9/xmake-v2.3.9.tar.gz"
  sha256 "74ac394a71a137874393ff0f112b048a3c1c88c05efaa0059bb2268de9f4f672"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9102ec2c17817f4aaf96710c73f568078ceba2201d35fd33cbeb09fc5a52c3e7" => :big_sur
    sha256 "97601c30b48b566feede80e8c546fa8a7f8f47340d5fa99775ae89fa21ebf798" => :catalina
    sha256 "1d38ca72d9c6b48a735ad97896956a795a74e85f99318eb84eb8ac856d363628" => :mojave
  end

  on_linux do
    depends_on "readline"
  end

  def install
    on_linux do
      ENV["XMAKE_ROOT"] = "y" if ENV["CI"]
    end

    # This should probably be automatic in future versions
    # https://github.com/xmake-io/xmake/issues/1190
    args = []
    args << "BUILD_ARCH=arm64" if Hardware::CPU.arm?

    system "make", "-j1", *args
    system "make", "install", "prefix=#{prefix}", *args
  end

  test do
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
