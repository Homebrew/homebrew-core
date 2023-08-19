class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20230614b.tar.gz"
  sha256 "d02af6902ffdeb718349b84113df3dc415ce8e40c6e42bb739756274d9ac4cfa"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "36b9c6763887b010906a67e4fa6adf3e668767b49a3d603bd99a0db5bcb9990c"
    sha256 cellar: :any,                 arm64_monterey: "f60d4d6307e5380fcc80ed252e0dbed5023090e27fe5515defa43d11b021e789"
    sha256 cellar: :any,                 arm64_big_sur:  "7d0e29db0bdcd36997f4c754b8cba5770e945694a64fe2c90e0b8b09d9afc418"
    sha256 cellar: :any,                 ventura:        "d9ba8341b1e2bbffe1287313394c60edcb38789781d7e9b8dcd7e8d1be32bee4"
    sha256 cellar: :any,                 monterey:       "075d40f63b7288c65da93b07a1611502bb807bb11d84429f74eb2b6df8548021"
    sha256 cellar: :any,                 big_sur:        "0c6b0f1cebc48a2043e1a6f20e0ea42f2ff738dd336c1bd5f3aa01eacd101a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec47504617b79ca9d2f394558dba402041f149fead66d09d9f325d70ba08d066"
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
