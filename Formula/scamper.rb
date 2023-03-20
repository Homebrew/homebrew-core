class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20230302.tar.gz"
  sha256 "84e8b6f34417559e9330ebd269c8cebf68bdbd2307ef1738ff07c5e87776cd4f"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "49226c7e0e770359af52804c9a47ec4051843f5a3bc2bdb9aaf69ded95fad994"
    sha256 cellar: :any,                 arm64_monterey: "b946d84b2960836ac3e6c2fe79ceabf046bd545cf27a207f0bd60df19db6f1c7"
    sha256 cellar: :any,                 arm64_big_sur:  "82be91e3e9c87e23413a6d6601a1366480dcf3891ad2d7e47f5459a3c36c0b92"
    sha256 cellar: :any,                 ventura:        "60b171a27008dce7ebee9d5f69ae692753709eeacf8b687bc191494253f83e4a"
    sha256 cellar: :any,                 monterey:       "09b739b442e50676aad6295b494e4dea8d6f55ac613e9266b1c899f9480348d0"
    sha256 cellar: :any,                 big_sur:        "356c5ab36ceb30e9e57018f00b354577a09455d79fc11ef916da7121fdfde71c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a53036dcf640b28edfbd4bad22863637b9dff7f290eaf2082ebd5d1e51b4b70f"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scamper -v 2>&1", 255)
  end
end
