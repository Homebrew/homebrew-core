class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.5.8/xmake-v2.5.8.tar.gz"
  sha256 "9f0eaa823ff4d0fab5b52e01b62f6db860a2ed32402ab51738903a07584c91cb"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90b63301078c6c9108acf749ebd791cde422a27a4eec32408dcbb4fb15c03d7e"
    sha256 cellar: :any_skip_relocation, big_sur:       "ad540f2a7efeb396a3236c074877401b72e8b49aea70e8bcf420ac1d87db5b26"
    sha256 cellar: :any_skip_relocation, catalina:      "7d5d1d19cb34c212319f0f742be4f76fa5bd7c1c4475a4c299dba3f2550d40d5"
    sha256 cellar: :any_skip_relocation, mojave:        "62071446891eaa516a884653279610fdc555d0f3a68106186fb13c3d7ce59db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec70d374423b44e0a1948e4e6d2f1a8f33174b06664990c5020764b1c0d0cdc8"
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
