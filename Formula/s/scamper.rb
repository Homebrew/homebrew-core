class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20260105.tar.gz"
  sha256 "31aeb84f82019052d12d85ebbf275ff1a1d465c0a80d1283e973445cbbbb75d7"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc1dab292233658922f8aa36ace6b77838684052e90d620914cb59172f558d11"
    sha256 cellar: :any,                 arm64_sequoia: "349acebd63d3bd7e3e4672fb3da3944ca12ef12145ab11584d01e48f73edebe5"
    sha256 cellar: :any,                 arm64_sonoma:  "2aa2fef8c312a1deb13bd60fbec3dd2ab5aa77cae50654fba5431357a671fa3e"
    sha256 cellar: :any,                 sonoma:        "40900ad2efabd493b4fc3bad503fff05df43e89b1ee4bcb93f41d9514a4ca79b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be064651416cb723e0a9eb516f04f486ef2dd09e66e0893bd81153ec53848862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce0a8d08e6840e368dbcc8780de5aa16ed64f3f3f7ee09d7ade199fb54889126"
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
