class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.7.7/xmake-v2.7.7.tar.gz"
  sha256 "aa05875921896ba4a07ac10a876979326367370631599919537fb2f8ff096750"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8185d7ecaca3829491c6b707d23ac37ff763de2e21c92681600229c01a2d6338"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "506a82530a7cff0217d6fab0a8e378502e9c56a040402152787906886c9d92da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8866311fc2b085199cd46946801ff942ebc9c712c1e37f49b1d2ac779e94cc4"
    sha256 cellar: :any_skip_relocation, ventura:        "9795ba1a21b591fc47e9cf6764a342d47c0106ed4f052342598747b4bd9a8eee"
    sha256 cellar: :any_skip_relocation, monterey:       "0bc50c40cc1c17f4049c69ae8b463ba5ef230cb8347a34d60bd8bcf973d1f784"
    sha256 cellar: :any_skip_relocation, big_sur:        "882fc7e3f8bcb217156b2f54dcfc548bad96e608cbcee14efdc20c134abd3aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b333e94c8ef4da5c3c170973c83b0c79fca68b8240d77d233f9d6d312d9327e6"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    ENV["XMAKE_ROOT"] = "y" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./configure"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
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
