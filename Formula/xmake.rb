class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.3.8/xmake-v2.3.8.tar.gz"
  sha256 "21eb3428036a22d5230fcf765ad64b19941896e27118ddfe25aed248c3091331"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a89fed1ec09cacfbf34950727ca18b1ec764bf71be1371d87094189fbcf593b6" => :catalina
    sha256 "44ec44e4422e1717b1cb2aca8ddbf6a6bc62758887e93303096d61fc777e282a" => :mojave
    sha256 "4f26742105d0628cbe437862b1e69b0c4fdf9deb40e593c5d2a70dd2897257a1" => :high_sierra
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "build"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
