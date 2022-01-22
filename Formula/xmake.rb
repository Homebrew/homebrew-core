class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.6.3/xmake-v2.6.3.tar.gz"
  sha256 "43c739b8faa3be986f95421c7ba1e135ff18d4723fb88b7e0bb0cdd27ef37430"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64de68ec1f3b4c65054398fba3ba7f57de8ac68f2a9fcb6924f88a4a47ed37a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64de68ec1f3b4c65054398fba3ba7f57de8ac68f2a9fcb6924f88a4a47ed37a1"
    sha256 cellar: :any_skip_relocation, monterey:       "3ac594add4d87340c56376ba161dd58866bd0a441b43563b248eb6773ddb4dfe"
    sha256 cellar: :any_skip_relocation, big_sur:        "798922e0a67b774125825507cbb6729554e8ed6b9332cbd03becf9b1c872aae0"
    sha256 cellar: :any_skip_relocation, catalina:       "acf12d34fd511b2cb51ca71ee5eb1654c23d06743e5d3446f5a5a21b3125932f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "094af63335ec54cd5c33a5cde34d9310462ba4e2fe64789930fd79f835bf21b5"
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
