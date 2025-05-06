class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20250505.tar.gz"
  sha256 "f0a8b976dded0cd033e959c3bd2d80635b06248c5a41a15e888fb382748903a9"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0895427b6ba06b5298fc19160c3148d7543eeddc7461a26abd14c82d6652bc4a"
    sha256 cellar: :any,                 arm64_sonoma:  "d11fb11be4154ff4f1c33a7d5cc5b89118974f2dc8d49bedca895168ffc0f752"
    sha256 cellar: :any,                 arm64_ventura: "0216748b7a449370af6aee51e7a90c6a3f6edd33c754d3dd9fb33b880d11c166"
    sha256 cellar: :any,                 sonoma:        "4111104fde099407576ca3af02a75ec7ed15d25a04b4c8c4a93e0181f7f6e6af"
    sha256 cellar: :any,                 ventura:       "0fce24676d40c9efa407be397be9df7b482e3b44a3bd9b150c2694a63a43bbd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e83e1779f6eb9cfc720f163ce5f2bd6444648dae27257505f63413eaca051915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4910b3790fd4fca3ec622d3eb9d26c4494c5c7be78ed7886fceaccb8fd758a0c"
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
