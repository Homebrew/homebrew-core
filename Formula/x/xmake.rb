class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.8.1/xmake-v2.8.1.tar.gz"
  sha256 "9ccd0b57709568b35b07510a8dcf98c22af6690ff15a0113d82bbe921f74f25f"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8478eedd56e7059ba1096a27536b11d74619654112c46e19f25655fbfe959a4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5025f899eb83ca524d4e8f9b44de00dc2841f4ad5be7c03af6e39035ff4810f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd13d9706445bca3d122f97e2e6956b995591a819fbb66d4b37eea648fa3a97c"
    sha256 cellar: :any_skip_relocation, ventura:        "508f5de2bf3585dfc9f43f140714b67c5308ce938ca2ae3f0d87d6d56cffa12b"
    sha256 cellar: :any_skip_relocation, monterey:       "a491484438c0bb35d92ff692f039cd348a49d9b3b5fa96702485c2e3229616b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "49be2ecd0c67dcdbf50a60967df546ef43ebe585f0de6644f2ae14654ec55d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "524366ae366501074e9b50c07b5a2cc50ec054aba3e5e93997f7eb913cdd8a4c"
  end

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
