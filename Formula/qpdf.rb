class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.6.3/qpdf-10.6.3.tar.gz"
  sha256 "e8fc23b2a584ea68c963a897515d3eb3129186741dd19d13c86d31fa33493811"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^release-qpdf[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d73e9ba981fe6c063254b713d7a224b20b96f8395ed8adbab64793a5e9075d28"
    sha256 cellar: :any,                 arm64_big_sur:  "e1b12dc5b9fa7bf382d82482349e3863b2896702c5f20abfbe54d293cd0bf06f"
    sha256 cellar: :any,                 monterey:       "e7dadd66b88ebbb70f2f675063efd6b2db51cc2229fdcf5f4455e94755a3bad4"
    sha256 cellar: :any,                 big_sur:        "584b60be8b5b00a8a13cac2ed0f91570d647fccc9bf784ed470f36f46feeafc8"
    sha256 cellar: :any,                 catalina:       "a094fb34fd6834d6d813fcdbc9cc93f1f8a6c77f140867cdb10ff7f890493d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72c36f09952ffc50cbde983d248609d7c3be695103348ebf1cdafc84b3d8a608"
  end

  depends_on "jpeg-turbo"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
