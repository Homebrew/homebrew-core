class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.6.7/xmake-v2.6.7.tar.gz"
  sha256 "206d9532e80722292b944ada91f558e0b265a176e3476eeb3e1633ea53bb15a6"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db7802e00991af265efe739fd4290cfa91865d3b1796d8294d697d3ea8292e18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b06e313702cb562dfb84178f82b024966188f3365160eb1c6937b963fc70be9"
    sha256 cellar: :any_skip_relocation, monterey:       "126f1a69145a7e72877490884160a576a5e314a7b6b03ea635ac989b77cf7a61"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7e3db5af202926e85be7b3def8ca20fed17f19b615fb3c23588d85f62a475f1"
    sha256 cellar: :any_skip_relocation, catalina:       "9958ab4ddef0e27a9abeee164671deb34c3999c3c0faf74b8b224cef6eac49f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c67a43fc75ddb8fbdd898e15ba8fc86a24ae525b2ceb73f92fb668ebce06266"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    ENV["XMAKE_ROOT"] = "y" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    ENV["XMAKE_ROOT"] = "y" if OS.linux? && (ENV["HOMEBREW_GITHUB_ACTIONS"])
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
