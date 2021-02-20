class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.5.1/xmake-v2.5.1.tar.gz"
  sha256 "809347dcd08659490c71a883198118e5484b271c452c02feb4c67551ef56c320"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7031171595fd4a98fadeff92ed6310e18f88220d9fb2852a170a0c952b7fea30"
    sha256 cellar: :any_skip_relocation, big_sur:       "1056810f311df733789d9bcdd6a8381019db4f620ef2ac0e684df45048123d6c"
    sha256 cellar: :any_skip_relocation, catalina:      "af687b62d4a9d802d91ce6793c1b186d31aef77baeea1bf873b2accae8205f0d"
    sha256 cellar: :any_skip_relocation, mojave:        "832eef81f79a01ed8af0cfe6a75ea5dc3ecff56edb60c42ea0991809ec80b49b"
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
