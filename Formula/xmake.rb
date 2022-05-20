class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.6.5/xmake-v2.6.5.tar.gz"
  sha256 "868f109f660d3f42d8f67aad71b8075b7c3b606d7529956bfc94ad052bb8c1bd"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85b7c3125fecdc983d44faa26b29f6a03e997fdfcc7dc90a8af5fbf1e60e1c73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6afc9d2060838214ca517c1f59271742519baa8c429a952fd3c04952005323d"
    sha256 cellar: :any_skip_relocation, monterey:       "71b7f08020ce93d0519d0cab7fa0aa081ab2f3880b802dd2ffde04d092f238eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dbece780215f07b4769e47dd1fcb044553272a75fb42237d118274547fc9aad"
    sha256 cellar: :any_skip_relocation, catalina:       "41af3e93e9539e10df6ec63841a6cddbaec0df56ef47b56abffe05f7da4940d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e89453aafcecf53467b9d1a0125c37cda263314ca61bd4492d4acf61445501f6"
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
