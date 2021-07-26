class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.5.6/xmake-v2.5.6.tar.gz"
  sha256 "79e65766761642d574ac24f50c4df2b896a3d9fb649a37746a9d9c67073d5998"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "92d5686c98e90835b2088117c4895bd6042874d8bb1dc453619bf7146d344462"
    sha256 cellar: :any_skip_relocation, big_sur:       "460449a9f8a6eb606a0253668b3764dd06bf3c523dbce8580a72b3841c542cd2"
    sha256 cellar: :any_skip_relocation, catalina:      "b46dc87d438d09c8f855997357afabbad0a5491d4ff8bd99c323bb25cdc3f666"
    sha256 cellar: :any_skip_relocation, mojave:        "e0b91549983c6ea9fd8c6949eebadd7eba13762889e066b8bed1d9f3b88e4f67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31d6f41bfd53973535a912992f1274a766b35082a2fb94fe92353d9f7716d2f6"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    on_linux do
      ENV["XMAKE_ROOT"] = "y" if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

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
