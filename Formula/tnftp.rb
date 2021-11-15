class Tnftp < Formula
  desc "NetBSD's FTP client"
  homepage "https://cdn.netbsd.org/pub/NetBSD/misc/tnftp/"
  url "https://cdn.netbsd.org/pub/NetBSD/misc/tnftp/tnftp-20210827.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/NetBSD/misc/tnftp/tnftp-20210827.tar.gz"
  sha256 "101901e90b656c223ec8106370dd0d783fb63d26aa6f0b2a75f40e86a9f06ea2"
  license "BSD-4-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?tnftp[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab84fe5ac9eff0c7362b22793c3678b427cded2cf30f27dd41799e96039a4b65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70ef6eb17e9644707e16b95e69d9515ed73b8d5e1b965d0d44b8c16e9d36bca4"
    sha256 cellar: :any_skip_relocation, monterey:       "1e30f66379f0a97e015bf3133cd3fa53b8f322919e9352e4d0ae25c28151b201"
    sha256 cellar: :any_skip_relocation, big_sur:        "543c3b1220913421326418f4fb346cf76332bedc7d5f5e19d4e02e6653833387"
    sha256 cellar: :any_skip_relocation, catalina:       "10fc0ee307e739bc3a0f617167fe6027cf37573efd47a555239599e226c7e8b7"
    sha256 cellar: :any_skip_relocation, mojave:         "0bb7b548299599ad06fb746a00a4bc3df48bff90615280c3786d5a0ca04a4089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9afa6b6d747eea6fa479010921972e5479c1238c5ccd209f75852d83775c6bc4"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  conflicts_with "inetutils", because: "both install `ftp' binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"

    bin.install "src/tnftp" => "ftp"
    man1.install "src/ftp.1"
    prefix.install_metafiles
  end

  test do
    require "pty"
    require "expect"

    PTY.spawn "#{bin}/ftp ftp://anonymous:none@speedtest.tele2.net" do |input, output, _pid|
      str = input.expect(/Connected to speedtest.tele2.net./)
      output.puts "exit"
      assert_match "Connected to speedtest.tele2.net.", str[0]
    end
  end
end
