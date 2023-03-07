class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20230302.tar.gz"
  sha256 "84e8b6f34417559e9330ebd269c8cebf68bdbd2307ef1738ff07c5e87776cd4f"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b0d58bb4e76139ef8283b31a635034619268cfef926c137567f7504ce1250009"
    sha256 cellar: :any,                 arm64_monterey: "92774f0227d5cb21d5199b8d30bc863dc47cbf9bfffa60219c8b133b3d347967"
    sha256 cellar: :any,                 arm64_big_sur:  "9918e6ff9657ef243c2e7ae48ba658dda02666ff34e41967b16364811a4c37c3"
    sha256 cellar: :any,                 ventura:        "334658c4d66c14d573cda58f83a8061809da8f611d8d735f7d0f107da8151527"
    sha256 cellar: :any,                 monterey:       "c34d1a4c4d0d20499964cc3dde933b30b22ad42e1c5a8655eaca7fadcabb30ed"
    sha256 cellar: :any,                 big_sur:        "f25b549b9ef2246ba6735b735c07737b6850d9d83d1a84b51e5884947e029dfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27184660b4159cdd166040a20f6d1121cf7b400a3ecbfbef890d4c95c6e15950"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scamper -v 2>&1", 255)
  end
end
