class Vtclock < Formula
  desc "Text-mode fullscreen digital clock"
  homepage "https://github.com/dse/vtclock"
  url "https://github.com/dse/vtclock/archive/0.0.20161228.tar.gz"
  sha256 "0148411febd672c34e436361f5969371ae5291bdc497c771af403a5ee85a78b4"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/dse/vtclock.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25259a2e776866b62ab94a2b3540f212ff1210fb5bb6aa8bc64a979f771053a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89f35de639c75067c0b64b5df9642a6b08652b8574eb403f2d51038362b7c16e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ba3ce880fdedf82e166ed0f7f7a4124c57510680d5c591fd363ac14887618f5"
    sha256 cellar: :any_skip_relocation, ventura:        "a9d0ccf5a02245e652c282d971eaf01115c97a43b176d4f2f4d41656ba013112"
    sha256 cellar: :any_skip_relocation, monterey:       "d8623d74ca8e085cba72cfcfdd04c87327dd5bd9bed6b6f0c5b60181448922fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "747b98b591c6a732012006db26bc8cdd871509e6407f557a1b616c54d2c2079d"
    sha256 cellar: :any_skip_relocation, catalina:       "77d6846683ebe827ad322e81cd281e79d28b5e93122aadf32c49a1566b1c9f2e"
    sha256 cellar: :any_skip_relocation, mojave:         "1f4d80e05dcf1c214a317d54057674f496ff0a063d9acaedc3e845d212c627bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70959665bdcaa3a6909a6b3e8f13e2b81c50fd28ba845f69af0cbff34df1d209"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "vtclock"
  end

  test do
    system "#{bin}/vtclock", "-h"
  end
end
