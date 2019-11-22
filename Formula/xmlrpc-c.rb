class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.39.12/xmlrpc-c-1.39.12.tgz"
  sha256 "d830f3264a832dfe09f629cc64036acfd08121692526d0fabe090f7ff881ce08"

  bottle do
    cellar :any
    sha256 "9fc26e1b11898f9739f5711d0d4d8899463f6f28f65b704fbde70e753db10dae" => :catalina
    sha256 "c49b16bd3cf25e03b498474c56e19f374589ac81b787c5aa9dc16e4fd99fb6dc" => :mojave
    sha256 "c6c39ccd6891e1e9ce07f153a2e16d843cc8c5a0ec9eace09c84a34543115933" => :high_sierra
    sha256 "19784c94e65b73ea524331452a28458eaa29b78419955805226a50f1632ce6d1" => :sierra
    sha256 "503a064edf4638c671b6377d91045c7f0990203b9b8d6f873d84415c8c98b614" => :el_capitan
    sha256 "6fb643c4bc7e7fdef6c276f533eedafe77d325fd505218bdbd8244af5577db31" => :yosemite
  end

  def install
    ENV.deparallelize
    # --enable-libxml2-backend to lose some weight and not statically link in expat
    system "./configure", "--enable-libxml2-backend",
                          "--prefix=#{prefix}"

    # xmlrpc-config.h cannot be found if only calling make install
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/xmlrpc-c-config", "--features"
  end
end
