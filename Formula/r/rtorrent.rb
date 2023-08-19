class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.9.8/rtorrent-0.9.8.tar.gz"
  sha256 "9edf0304bf142215d3bc85a0771446b6a72d0ad8218efbe184b41e4c9c7542af"
  license "GPL-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "88f96c46480eba28bf0243f70bc6985e6f7b423465236068f34fb33bf6a59a2c"
    sha256 cellar: :any,                 arm64_monterey: "c6ad3c296e29e64ca71ebd6edcb3d626a79063518b0b014f0241620535407021"
    sha256 cellar: :any,                 arm64_big_sur:  "cc20534a382138c8bab8db453bcb6a219390eff9d7501df4d0750fe3e1f9da6f"
    sha256 cellar: :any,                 ventura:        "70d2dec43d412ce347f231316825039633582a810e1e955500a05378d4345173"
    sha256 cellar: :any,                 monterey:       "e326ec1561580dadc4afcb3694302626157d1bfd134cf48641982599015e2dd9"
    sha256 cellar: :any,                 big_sur:        "be5a664f10bf69e6295b76abebb0c6b3bebcf4101fbeaedb92f6f95e798351a9"
    sha256 cellar: :any,                 catalina:       "18df02b680e7dae9230ce424b60b95bbb65a7f34f62f269bd5126e2e16ccc369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb9b02122a6be3b40d5dd3db81449fd832e60504ec1aabdb7a20da4c959b1f3c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libtorrent-rakshasa"
  depends_on "xmlrpc-c"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    args = ["--prefix=#{prefix}", "--with-xmlrpc-c",
            "--disable-debug", "--disable-dependency-tracking"]

    system "sh", "autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    pid = fork do
      exec "#{bin}/rtorrent", "-n", "-s", testpath
    end
    sleep 3
    assert_predicate testpath/"rtorrent.lock", :exist?
  ensure
    Process.kill("HUP", pid)
  end
end
