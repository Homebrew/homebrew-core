class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.6.8/xmake-v2.6.8.tar.gz"
  sha256 "2f74698abbb009dfe0e80399a94e7a903f2fb12c2fec503cd6152a52a1469013"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "476a428f8f8351e6b652ab876ecd79b19455544ff87802c3472db968e1e94c0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af66a72b94b2e876798e931a425aa10a23a5484472e8aadc8ae2983930949528"
    sha256 cellar: :any_skip_relocation, monterey:       "af0797075b6e87d86811c2b5a2f6a0f5d47f8d1a3a7f3226eb703b6ffbf8e31c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d95c087f3fd2d9090ffb99c6dd3808a972690f8b519f7801fb7e10d7c6a29e0"
    sha256 cellar: :any_skip_relocation, catalina:       "6e47be25429d199aa45943e92a5d70146a10db363f365f7c825f3f97730a66a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba4112db2763133fe48ce9c7975ea88162920c0c210d1b75f07ab704f01f772e"
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
