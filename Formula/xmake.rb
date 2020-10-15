class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.3.7/xmake-v2.3.7.tar.gz"
  sha256 "95f1cbfc090b06b615efcf89195798eb1f6f0928e8ceeadaf9b03d9dce867ff8"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a55380eadba1127bb768054d14c7bae6fbef962ef33b2ebdeb3e57a651f5e3ed" => :catalina
    sha256 "6c1d597d3d717a59cb9c76b398aef1caef7f0b82baf95b20f977e5709446944a" => :mojave
    sha256 "9da8e60e07ec15de03ba200abeea16664653512144e9546939dcc3e91ca4d76a" => :high_sierra
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
