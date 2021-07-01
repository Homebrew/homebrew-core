class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.5.5/xmake-v2.5.5.tar.gz"
  sha256 "47537ecc53aa73783f630b85c30ae6b339cda928c509887b013c49f23b9f3528"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5a38b802c57b6190760971adcb76f4cbdffb6c382dcd506648977c66a00d67d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9d543ef49194fca52d4a8003d13d146cbe831da6e99c17e3cdb5230a13f4c4a"
    sha256 cellar: :any_skip_relocation, catalina:      "d537ab687c86483e8c1913b2478728091df6cbcf634759e0be661c1fbdab9089"
    sha256 cellar: :any_skip_relocation, mojave:        "4c90845f661ae1a80606cb1eb887220d258dd4a1c2450577472f438ad046ad98"
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
