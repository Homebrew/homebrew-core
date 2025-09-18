class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20250804.tar.gz"
  sha256 "1ff01e0875f17d6e0c8d75f95e2b161c644e471e574eb385e6a979bfa8bd54f0"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7cd99dda08f76161e95f8756458c53d4a1cda90ff0ee44958b3b4b1a2b1cac44"
    sha256 cellar: :any,                 arm64_sequoia: "0d6f58901cc39679bdb95e7d5586218c4b8648773b60c3ebb369ef9af804a20b"
    sha256 cellar: :any,                 arm64_sonoma:  "3e700166d6daff1178b4fa4401ba17a57757c280f34e70244ee1ae2cff5548e9"
    sha256 cellar: :any,                 arm64_ventura: "23a58f9f45c21d56844bc43dc0bc6ca3ad65fe246a35e311dc150b2934e8de2a"
    sha256 cellar: :any,                 sonoma:        "dbbb7ed6f99f66542d564d77a12ef1fd7e454b789932665d02accc1789efca6a"
    sha256 cellar: :any,                 ventura:       "8eb639434a58676ea3fc4efab84d01f924c3d0c3a1d68c892470d008d3598e9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "700d21a444f6b4f49346837b1b585e5ad728f2ccb25a5c115913dd2f313b2783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6ff33354dadbc181aa4a73ea778c9ec54b47d2f3f1f02a307f657f57854d682"
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
