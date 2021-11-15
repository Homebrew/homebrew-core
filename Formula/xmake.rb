class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.5.9/xmake-v2.5.9.tar.gz"
  sha256 "5b50e3f28956cabcaa153624c91781730387ceb7c056f3f9b5306b1c77460d8f"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36cd5067ca7998d06b6266b6233b9ebd9395896b81fbdb1bb585fec6b39d8482"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8bc227e357e5438787a1d3c7ed15a65d7ad020fe48036dcbaba0d8851e25c86"
    sha256 cellar: :any_skip_relocation, monterey:       "5e0ff48a37e6e62108c798493e072be38fc8d9d0b5274fd3d91d59da0511625f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbe0397acf297160003a8f8f73906e44afc746033d4bf7591cd09898caa77dbd"
    sha256 cellar: :any_skip_relocation, catalina:       "12153f7e13ef7d654bba10bb908f368c9092619e39a248f1398c033671a261d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e72219ec96d022d8cb10aa13fcdf60dcb1de47d4fa674bb086289827adbfd03"
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
