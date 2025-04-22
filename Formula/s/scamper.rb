class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20250401.tar.gz"
  sha256 "4cb69c18a19027d170f05a7d3e81aa4d155759698a27630229eedffe3184af8f"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "83d974c5b535132ee7635e87847c53cc1890eb383d7f0ebde6ec213af34cc601"
    sha256 cellar: :any,                 arm64_sonoma:  "4dc91ca6d8d032cb088158ef698850e75ee59ff7476699fa615d179ccb918c3c"
    sha256 cellar: :any,                 arm64_ventura: "0295542c351ec680715450b7210fcd4a8d6a2a9ccddaf1d6172f095e2233699a"
    sha256 cellar: :any,                 sonoma:        "3d9493d5b75cd2cc9223c00cf3f664fe26223bfd73c641c1427b5616600489bd"
    sha256 cellar: :any,                 ventura:       "14b5cca325c67af3cf0295fbe45e3d0975a68ad9b4f6457fd299fbab1df94865"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d83f5432710b382caf173115303022cc73d45f73126ef886d46c2b8e39deb36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89fed67f7fef394cfd81854e82e4462c5c9d8e318a90a9f9aa5aa8706cbe0313"
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
