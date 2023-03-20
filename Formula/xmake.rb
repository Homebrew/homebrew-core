class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.7.7/xmake-v2.7.7.tar.gz"
  sha256 "aa05875921896ba4a07ac10a876979326367370631599919537fb2f8ff096750"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f6e043545b1139b92e822c461c3ed9711bdec3e00371fdd7e6944936e659f88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b4a084dfa37d6cc2c5c61a9b00e6bac41adfc4d8491a01f6ce393830f08de1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a1cdd678a8e80f89c4136875289c22be582fc24a0aeef198ff18245320ea5d1"
    sha256 cellar: :any_skip_relocation, ventura:        "01014f446bb29957997effd9b22161195e9d8aa5e60ea9fc0695600d6533c975"
    sha256 cellar: :any_skip_relocation, monterey:       "a3d9445d1c8bf1257c39a1d3d69a066ce8c6d23aca364f8c72145df036d602ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "af9f347abd4f5657dd4d85738985bb94ea028811bef8894c62c2f9f43bc5fba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e8aa1a524da6d94bafd387c68922ef9b5b7b621a282f757a55005cbf1c33c18"
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
