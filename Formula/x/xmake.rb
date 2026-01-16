class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v3.0.6/xmake-v3.0.6.tar.gz"
  sha256 "1f7bd9ab7f7cbeade4ecd81f3580898e8d78aa5f64cea44239a9506ff41bc397"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebda18fb4d3854af6c0e21dbcb1e6c6bbaa3932a11f8ae40be367e8ed1f595e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2ba1299114ecd736c834ef94a804fd174ccbef3543140b2cd0569ec7c1f299d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2fe1b8aba230b72a2eed77db4d340114bc2c7b3c1bd66eb18f0971f29ee6c7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a5738769949725ec1a628eabb1b5b12db49d3ca1d5e1006d06baaccb318853d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e2e0ae8aafbccd627672a4f522c43b3c89143053c98fe4e74cbb58eb32f9012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cbe6c49d57301dfeeeab4aa2ca8ca946dfccbf481abaeebc8c3fa5cbb50a25d"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./configure"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV.delete "CPATH"
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
