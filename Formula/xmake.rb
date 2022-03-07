class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.6.4/xmake-v2.6.4.tar.gz"
  sha256 "ca8fb4f269718bee06078241cd72ec6883167f493fe11d623a0d37419b2a9ffd"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5012f4bdc552ffda0fcb99a3027027c746e7f251ca12490ec4d7ced17228f68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69f9dcabb4dfdb0b384fe711b715925ee9f16cc9a2ae4987da25b9b142eebf9e"
    sha256 cellar: :any_skip_relocation, monterey:       "1db57dd8b6eedc65adef912256de54fbaa907af9fcaafbf3353ff1a75890f041"
    sha256 cellar: :any_skip_relocation, big_sur:        "1db57dd8b6eedc65adef912256de54fbaa907af9fcaafbf3353ff1a75890f041"
    sha256 cellar: :any_skip_relocation, catalina:       "136d7dcb4f6d7ccc0a3c36b08022db1f0226785b694b4be5a5541cc2b29dddca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09d8ae11d82699da8f31ebaf028797ce06f6f77c13addaf22482281878ca2758"
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
