class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.3.5/xmake-v2.3.5.tar.gz"
  sha256 "5be491fd023333225ab347dc209f18f453e61d52988ae84f485e1b2552a440d6"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ecfef90dabbaa9a507b4bd17eba62a2f622f2e4e53324251db699e4c4cc3fb85" => :catalina
    sha256 "7009ae9ee758bc803ffa46267a1595f639fd350a819af79a237575d692bdb06d" => :mojave
    sha256 "7cd0cb7c5727d885904809c64859515f5d83a7e20a82232377a56333af37d9aa" => :high_sierra
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "build"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
