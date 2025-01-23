class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20250106.tar.gz"
  sha256 "d746f15d58b0eb6d95f263e8b4062958c1586082ef7e91d31eafb3ca4c38c080"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b2cd1fa7ffd6adf0b184403d1add83858827195fc2e32ba46dccfb3a39fb29b"
    sha256 cellar: :any,                 arm64_sonoma:  "397a461ce1691e2d133ce77513d3aee4fe9e581bcdf7ad495690f568b745ae32"
    sha256 cellar: :any,                 arm64_ventura: "665f074cddbdeeac003761f8bcf554c1e6faac6fc3e2ba2e0231b124fcc6dc4f"
    sha256 cellar: :any,                 sonoma:        "2b51cdfdb14b7ececcffd676a2d10d7f4cb115f434d3082e1c65bc3dabd8d297"
    sha256 cellar: :any,                 ventura:       "4a5215e0209b5b2c7b118b6f00539a3685a55c48deefe64f6bdcb642a0e2165c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcd6b6861e880e9c2363a7665d24ca2ede02b1e7b0331c87baab43f81a15058f"
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
