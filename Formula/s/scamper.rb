class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20240813.tar.gz"
  sha256 "1f45921be2c68be4533c74d4a8ca45a61fc936fe59effd771f85af3c6c0ab3dd"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e5eb7f84a068f31f90f5071fc4b3f9d3f80c180efd53c1d2784fd307073abfad"
    sha256 cellar: :any,                 arm64_ventura:  "1f7ba6d25f3c3bc84f6a3eded8ffac963f4901fb9c3736c3a0b36da2e6a8f789"
    sha256 cellar: :any,                 arm64_monterey: "7bb49f1d0e39f31bc91f7d9771f674ffdd8c924ee9c97e6e95ea25f3417f26ce"
    sha256 cellar: :any,                 sonoma:         "c74dd4ca90ae3e84f3363294420841ba25c4ff23c1601c2f4ad27b2dfa72b470"
    sha256 cellar: :any,                 ventura:        "4daf10097a7384e29613ab989038cfa3aee6423f574ae014f660857ab4e35291"
    sha256 cellar: :any,                 monterey:       "47850019cb214381990ae27127767d365bcd88aea21684439f8188eb109e2f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e47be6739627ef2ebad22355fb8206471efed89bf6a51854597e59b1ab6de78e"
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
