class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.5.3/xmake-v2.5.3.tar.gz"
  sha256 "337edd61de22b043720556a02bf7b1c4d4881e200ecce6bb2406d0442f2db92e"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "220d389fc2514cf862d5195fe9b234357f9b74bd7691023cead693ec5b010e28"
    sha256 cellar: :any_skip_relocation, big_sur:       "56f270578493cd53be4f1bb37ecd6b030036934b6400a9c75ca46f785f9f543d"
    sha256 cellar: :any_skip_relocation, catalina:      "c4625a7aa1b407e59947dab90b540430c3064794a9ccc37ba0668715c6909cc2"
    sha256 cellar: :any_skip_relocation, mojave:        "204c820e69cdde9cf5ec6168b3fc1a4f3f58bc07d5f8d709b6a213de6bd3f43b"
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
