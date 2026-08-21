class Rpl < Formula
  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://github.com/rrthomas/rpl/releases/download/v2.1.0/rpl-2.1.0.tar.gz"
  sha256 "478d3c4c0a3b8ce3b7a1f7c6e576adb4a6a6e9d898ef6673994aac6d61ca7988"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8ecf751ed038cfcb047990b67f499b2ad4463cc0140f320a8237d44a8c69fcc6"
    sha256 cellar: :any, arm64_sequoia: "d1657696a2ff7db8d5ed76327473de914cb1eff1f6b3732bd3097f831c675444"
    sha256 cellar: :any, arm64_sonoma:  "2416e1bfd3cfd0ad7e53db57f746d97e6ec07018e3706425f177133e87857a89"
    sha256 cellar: :any, sonoma:        "0d06113c84c876308821d1d82d9f59242754b7418b41234ba77dff703d583aa8"
    sha256 cellar: :any, arm64_linux:   "596a3d6a1cce526af5265bd320d9ed9912dd7418035603ffceba0afae6fea253"
    sha256 cellar: :any, x86_64_linux:  "e5e77b94d63e31657b7f82df99ac37727018f3a53f83b6b5daed66897e7b87f0"
  end

  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "pcre2"
  depends_on "uchardet"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test").write "I like water."

    system bin/"rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
