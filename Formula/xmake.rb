class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.7.9/xmake-v2.7.9.tar.gz"
  sha256 "9b42d8634833f4885b05b89429dd60044dca99232f6096320b8d857fb33d2aef"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a9d9cd8702b193b82bbe777dbdbf3da73d9511f2868ca6c79b4067ff1306d02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b53c8759e3650d34615be9bc4a89a023d24193e67cea2522f8cffad75a07528"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57bda15dbc07e72803188efa471edc6d384d1c9e87a1a176452354e43cabf1bc"
    sha256 cellar: :any_skip_relocation, ventura:        "9ed2b58a6208db40191da62b3b5b6f4592ea65e4a2cb80a051df351fcc401ae8"
    sha256 cellar: :any_skip_relocation, monterey:       "e8a3ded587d8fbcac057b76a650a3e30048e870b31fd27f3484fd8a82ab14d89"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cd03bb9eb7657b0df84051ae233302b07bd73b8bd68c39920c0cab7b6530b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67a3a2c01262357778ef055e41ee1350f2ed5cc51771d9c728ea954e6c8ac6f6"
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
