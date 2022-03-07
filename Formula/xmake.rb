class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.6.4/xmake-v2.6.4.tar.gz"
  sha256 "ca8fb4f269718bee06078241cd72ec6883167f493fe11d623a0d37419b2a9ffd"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "304fbc5d5dc9f058a52e5fc34596ac2992fb8b10a599cac8cb53132ddc85f4dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "304fbc5d5dc9f058a52e5fc34596ac2992fb8b10a599cac8cb53132ddc85f4dd"
    sha256 cellar: :any_skip_relocation, monterey:       "1238a11b383969d646d468eacce1e72505d3dba055825141633e8c8c33cca00a"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaa62929287d0207c7e8e8f41002901babf920ceab9e2280f767442f9724954a"
    sha256 cellar: :any_skip_relocation, catalina:       "974ee287dceff056a0900edc1234410f4e5eda87bb4c6a73fd3727a46e2f5436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaf9c99ca22dccf829afc4cce4b21c50327fc12a8bc1d17bdda465f55a8a51f5"
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
