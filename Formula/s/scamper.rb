class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20240122.tar.gz"
  sha256 "7f7bf66bde9dc8819e4ef929afdf32aa1968763835258b12fb19cca04b2f9818"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d6fb122b8fa07ec7eaa3649c170fa338fdc403829da8a18a2590029dc0644184"
    sha256 cellar: :any,                 arm64_ventura:  "d2e8780527b96d722e7cff860c2f76d7d619ca472a9b411c272fbde721c52458"
    sha256 cellar: :any,                 arm64_monterey: "e4a822231f1d078e75409d4e6120b516eadb59bb1d768abcbd41897f3d88c6c1"
    sha256 cellar: :any,                 sonoma:         "44a846b1099bea4f534e4cc808292b19d42c09c56226252995342434e49c6b0d"
    sha256 cellar: :any,                 ventura:        "3f295f16fd4ea767e5640186a1da2479fdbc4ff5f0c4ed042158fa6073bdec02"
    sha256 cellar: :any,                 monterey:       "88bab5a1cd78af2c69f9e8e2a0c95259205c8c2350f7e4fe954ccc6bc1c06816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c03b175c3fc0b7162ea6763fc39977960d6bae0d013b3e5a944abac5311f0a0d"
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
