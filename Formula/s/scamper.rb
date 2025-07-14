class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20250630.tar.gz"
  sha256 "2bf708c63a0b6709e715c475a64d9827cd88ec8afd15452a39342b1d4f4358a5"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ef6cf53e78725672bcd391a2f2f2a119d0451729ec56f44da4708c8debeddac"
    sha256 cellar: :any,                 arm64_sonoma:  "03c53321509e385c5e0f580d0f0766adde12600694ca8025c9f85cb31be4fdae"
    sha256 cellar: :any,                 arm64_ventura: "9c5be80270226bf42a6b99d8beab1a92713871a4cbbfdd290e2d65f3e7c26f59"
    sha256 cellar: :any,                 sonoma:        "9c98ae2bba613b11e4b25e27f84fdd1ec1c678aa722203469cc15dc027b701e1"
    sha256 cellar: :any,                 ventura:       "b9088b0fa2d19b060d3e61e90427b7685f96349c4531a6bbf2956ec576764d88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b31deb29866a91449939b78f716fe69a4d60f460a0f7726a1b859784ded96816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c7335864fadcdcf4b6662ae53ceda8646cd0b9e0b7b0810f2319f4379c337e1"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "xz" # for LZMA

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    expected = if OS.mac?
      "dl_bpf_open_dev"
    else
      "scamper_privsep_init"
    end
    assert_match expected, shell_output("#{bin}/scamper -i 127.0.0.1 2>&1", 255)
    assert_match version.to_s, shell_output("#{bin}/scamper -v")
  end
end
