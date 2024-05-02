class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20240229.tar.gz"
  sha256 "f010533ccc257fe6459581a07fb55e4ecf160142a0f8e4077f661adccd3b43be"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "967293c0edb5cd390592946fab88326f2ba0a4d54a69257f0e2715f755eda67b"
    sha256 cellar: :any,                 arm64_ventura:  "cad3527a8597ec4755c8385ce29a69d65520168a4f3cdce0e89d2a14285f5dff"
    sha256 cellar: :any,                 arm64_monterey: "c986c26315e5b026c548de8004308cf924b234c87467ceacf518023af2028ac5"
    sha256 cellar: :any,                 sonoma:         "cb6b44dc4f41eaccb22f00a73261fe49236d7072a73a9eb003607f7af8898c0e"
    sha256 cellar: :any,                 ventura:        "3506e7542ea9a4caa44513064ee5b3307e381ca7de773d3945bfc7cacd863884"
    sha256 cellar: :any,                 monterey:       "847a8a809e25a7eedfed0f088979116f291556bc44f4154b679e35f6692a4e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87fe973ec2e796c79f9242f2ce06e49c6ea11624f802f92e97f0f569e074b342"
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
