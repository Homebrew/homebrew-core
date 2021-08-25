class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.5.6/xmake-v2.5.6.tar.gz"
  sha256 "79e65766761642d574ac24f50c4df2b896a3d9fb649a37746a9d9c67073d5998"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "373e4b13ef927cc2e77121f6d537cec372c1cb2d1f1db8ca896e099945afd49a"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c7768b7fd7494ce8881e5838f425010c9d1be2beab396a52c4d33cc307549f0"
    sha256 cellar: :any_skip_relocation, catalina:      "39fc10b7da100af608f5827984802e0b361cc83642e7aee075ff3c9a699307b4"
    sha256 cellar: :any_skip_relocation, mojave:        "2cd75a4ab1469fbc121ca9f9205cd36fea45dd659bbd99d44f81193948857188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bb06f6a0bb057afafffea00687581550ffae76a14afa49cfcc44f221a409763"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    on_linux do
      ENV["XMAKE_ROOT"] = "y" if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    on_linux do
      ENV["XMAKE_ROOT"] = "y" if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
