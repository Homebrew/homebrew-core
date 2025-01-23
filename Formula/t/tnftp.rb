class Tnftp < Formula
  desc "NetBSD's FTP client"
  homepage "https://cdn.netbsd.org/pub/NetBSD/misc/tnftp/"
  url "https://cdn.netbsd.org/pub/NetBSD/misc/tnftp/tnftp-20230507.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/NetBSD/misc/tnftp/tnftp-20230507.tar.gz"
  sha256 "be0134394bd7d418a3b34892b0709eeb848557e86474e1786f0d1a887d3a6580"
  license "BSD-4-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?tnftp[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "14d89deb1cf265a42cfa512173e91ee2e2eef8bc7e2748eb744fcdb4548e85a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11e76e93e1069f6e77346bde84e5d637d1b1b45dbfe22b5da7373c6724ec37c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9e3947ab41a6dd004ec70c6126d4ba9c7c34816e8a8c984f67f0d80617852ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e744b3ad973c717d4d41d5b81629d3ee5239a8ac72a4ff7dafd5269da4ee574b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cfed88dfedf303ba5559466fe67a0308d2a6793e9641ace8ce28d3876970bd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e02df44dd5efbd1c3e893e01b64d3facaa3c10a7b342f08c049a057b9205864"
    sha256 cellar: :any_skip_relocation, ventura:        "d1870a97a281b50e44b59a8132f2876d938b9602151eba9b7930ffc03326e849"
    sha256 cellar: :any_skip_relocation, monterey:       "f0df715364120f87c986db305942d7cc09f5088a7fd9ca3180348456818a3148"
    sha256 cellar: :any_skip_relocation, big_sur:        "5eff3aa4503a383db733447beddd456f2a53fe3fa7cb09c72805a55bd1a5ad8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "270f4da016155138c1d305eedd0d82a600396cf39f011ba42ef0456b898ca198"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  conflicts_with "inetutils", because: "both install `ftp' binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"

    bin.install "src/tnftp" => "ftp"
    man1.install "src/ftp.1"
  end

  test do
    # Errno::EIO: Input/output error @ io_fillbuf - fd:5 /dev/pts/0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    require "pty"
    require "expect"

    PTY.spawn "#{bin}/ftp ftp://anonymous:none@speedtest.tele2.net" do |input, output, _pid|
      str = input.expect(/Connected to speedtest.tele2.net./)
      output.puts "exit"
      assert_match "Connected to speedtest.tele2.net.", str[0]
    end
  end
end
