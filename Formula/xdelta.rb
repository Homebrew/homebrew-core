class Xdelta < Formula
  desc "Binary diff, differential compression tools"
  homepage "http://xdelta.org"
  url "https://github.com/jmacd/xdelta/archive/v3.1.0.tar.gz"
  sha256 "7515cf5378fca287a57f4e2fee1094aabc79569cfe60d91e06021a8fd7bae29d"

  bottle do
    cellar :any_skip_relocation
    sha256 "6039d48b18eb12f9d04ff36ac3762d0fa722f06dff6a234a9471ac127a4e9a87" => :el_capitan
    sha256 "4f7dec576387e2987edd57be6e1e9df740ee2c53207f61b775904f36936dee8f" => :yosemite
    sha256 "715d5c3a585879d25788ab619bddaaca1c7f7ff45b254277e5becb33c97f4857" => :mavericks
    sha256 "7adf5ae7a00473f5c12f8c377da22ad3f98a0ef4e179c6c0b64b03de075cc756" => :mountain_lion
  end

  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "xz"

  def install
    cd "xdelta3" do
      system "autoreconf", "--install"
      system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system bin/"xdelta3", "config"
  end
end
