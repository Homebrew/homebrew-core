class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.3.6/xmake-v2.3.6.tar.gz"
  sha256 "5d9b9dd8b357fab9e426a667a47381b5db54622cd2c5452584e4b960b410272d"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6782ee9186733d04854a208191c297a9b4587629293741ff566c37da44eefabb" => :catalina
    sha256 "6455cd31e4dc464b1b62f9d91fdcf95404d138ba1675c673e1b44caa09ae5a89" => :mojave
    sha256 "b760c23959906c23df696f6315c802bd1401eecfc1f3379fca9e00c4d9409f41" => :high_sierra
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
