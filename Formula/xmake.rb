class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.7.2/xmake-v2.7.2.tar.gz"
  sha256 "2d1159fd8910cd532b09315cbf7e3c8943df57f2b22952174c8cd04ba0358a14"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d91a81c577ff9ba5eb2a1f93687dd47bc8113e5f9d018ce315b9790ebec6937"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c55fcf18231d0b1b9ceab04489d923c6c4d24cdf9bc96157caa595c924307663"
    sha256 cellar: :any_skip_relocation, monterey:       "f8d6a0fad40948223c7a10beb5e22ca487816bcc4788a967634e389b0f714a23"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b69d673af8513c2fa37bacba80ced9aacc902f5db29a34acf4d512caa87bb8c"
    sha256 cellar: :any_skip_relocation, catalina:       "ad39be1a85c1c85dc7d6faca48ed7a064d63245c14bcf3440a15e6c5ebe64348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4b6afb39301d5be70dcc7cc94d2c7a0d12df991d3839130bd2bc80e7952a8a0"
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
