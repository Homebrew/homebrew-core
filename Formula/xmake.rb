class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.5.1/xmake-v2.5.1.tar.gz"
  sha256 "809347dcd08659490c71a883198118e5484b271c452c02feb4c67551ef56c320"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1eaa98c1e4392635f05c444b1056c93ee925299fa0bb2179b3ca9a16c9a39fb0" => :big_sur
    sha256 "36493b07ef38543e274d0d0e1d91a03b76ad2122cf733229f193c6c4b0150592" => :arm64_big_sur
    sha256 "82c6849b806ac4b28e916bf46d958c3d9de9de2a14161e5f6b240f7ab0064705" => :catalina
    sha256 "a230d9772bba3647568fc6c5fdb2c2d129c3ff35deaa78e530c498f39fed58f8" => :mojave
  end

  on_linux do
    depends_on "readline"
  end

  def install
    on_linux do
      ENV["XMAKE_ROOT"] = "y" if ENV["CI"]
    end

    system "make"
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
