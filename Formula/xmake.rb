class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.5.7/xmake-v2.5.7.tar.gz"
  sha256 "806a5b5a430227a1a006a4e2712f87389b56e9e27076263ae3c9ac7931d429ea"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9e83a1e8b536254d7efdb575d25644b3e0957f47220468158530a671b8266728"
    sha256 cellar: :any_skip_relocation, big_sur:       "58bce8747a74b63062537efbde6cd29657e4ca95c3d7f8bffcbc32d161966808"
    sha256 cellar: :any_skip_relocation, catalina:      "b43c7743ad8c50bb848e374bdaed62985f61bdcce1f6e2522b5ecb8b8c728f7e"
    sha256 cellar: :any_skip_relocation, mojave:        "dace16d198785d7e9348d5fda056dd63f8d7ff94da562f6a6289622f0a3a2028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e094a5c16b026ea59d31f2a088d05a41891966a7e44abb232cfc12e997d6bd"
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
