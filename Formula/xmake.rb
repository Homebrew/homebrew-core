class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.6.8/xmake-v2.6.8.tar.gz"
  sha256 "2f74698abbb009dfe0e80399a94e7a903f2fb12c2fec503cd6152a52a1469013"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dc175d56d217f3d7776c12530053428b330e3f439c9e9f3370349480e64e448"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c5dbad2cec4c2746469d7e1cd5abcdffd006b0fe19e4a47a8758f1863b0b6be"
    sha256 cellar: :any_skip_relocation, monterey:       "0ef3a364d758e311c4643bcd77462a365580e835f21c0bc13908fbb7734879c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcc32556cac33b11cbe915b6a10791e1416afa9bb0a2a26e1f9b639e36f1b01d"
    sha256 cellar: :any_skip_relocation, catalina:       "5b0c0d5f10049920305b6f68ccbba2ab812c7a7b4ff873827680e94fd0e2aea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfae0d8d52803802de3b2a6e497224b5d62026081a143e8ccf9bd607d2bf4cea"
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
