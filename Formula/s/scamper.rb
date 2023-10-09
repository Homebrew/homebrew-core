class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20230614c.tar.gz"
  sha256 "50a58ed36c7e7a4045717c5acc82b510bd2ad329f3b336b3504118e0280ad9ca"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "95c4dfaa470d4942d627790bcd61313f9a6aaabac135eb1c044fcdb4868b2453"
    sha256 cellar: :any,                 arm64_ventura:  "b147e2b7a492572a589546e9f4c25617a39dc3fbf27229f459e1b70b71ccb079"
    sha256 cellar: :any,                 arm64_monterey: "de4f4fa45d3f099859c9af7080c539aabc74874c8fb4095939036bc76d518449"
    sha256 cellar: :any,                 sonoma:         "ca1fa34015f71d6bf7e2a978644f822ec7a0b95fb49b770cc7d7c8f0a3f855a7"
    sha256 cellar: :any,                 ventura:        "94ae5582a3cb3d747e31bdf3dec5a101fd1543d730814212d06365d958e605c2"
    sha256 cellar: :any,                 monterey:       "71645d80a6b35f935784198ed7fab9e0189e49a895345114ae1b03c689fa158c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e04235f7ed90bc747e7fe2e6e349345bff97da5b5f8544fcd7638bc0f754dd39"
  end

  depends_on "pkg-config" => :build
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
