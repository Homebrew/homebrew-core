class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/6.1.8.tar.gz"
  sha256 "84d0e32af697f720c9f480f6b3e56b08f64251d90cfe2d8f163431c006c0053e"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a5cea737424dc51aa06088365589c49f5ec47053ed5936d26cdc17c74d63e490"
    sha256 arm64_sequoia: "de0723a6aec587e35f61d2d5573234cd0598433a358d4ab0295b2a6e082cd3ec"
    sha256 arm64_sonoma:  "f59d9d87712945fb6c54a4c4f08442f57454dc97e28ed6fc411a49e818bae631"
    sha256 sonoma:        "19daddc25463863726ab1c4599a4af8cf09f663959fea0188d9ca8532dad9d18"
    sha256 arm64_linux:   "c41d3a0202b24398bded99c9984dfcb19c3ff97880a0f9289a0a6b96e0a06f5b"
    sha256 x86_64_linux:  "d993f3f3290fc50ba65152e7766ce099bc7eeeeb45bf29562b4b78e3d9c34ee8"
  end

  # Required for r2pm (https://github.com/radareorg/radare2-pm/issues/170)
  depends_on "pkgconf"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
