class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20240503.tar.gz"
  sha256 "e6f42a7882689d321103225a0f60d079982af42cf1a66859a3ce91e63853cb09"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ac323639d5108ef258d74f26088e9ec8c9ff7353b1da45be34170329bbd6214"
    sha256 cellar: :any,                 arm64_ventura:  "3c5c5fe97e34db51e21e9f1a8d53e3080159bf1d2c243fb9972fe6ca3eac3218"
    sha256 cellar: :any,                 arm64_monterey: "618150d16b4b6d982ed27d54299340f061a4fc258795ca6443e2929bf0cbe628"
    sha256 cellar: :any,                 sonoma:         "0b3cb7eb170e13432ab45dc664e200f3c9036d72e416d1098e06d363047cf603"
    sha256 cellar: :any,                 ventura:        "fe85d7fb87888b39577b83fdfd351e3419b995c0cd0eecc8c1da76e7a5d0826a"
    sha256 cellar: :any,                 monterey:       "30fbfcd6f662fc8af7f4eed5063be81b5fb716a40bcb635c09fcaeab5fb5b013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3123731dba0751407f46619e3f81dfb5f33da24b7d536a7441debb7ce11aea19"
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
