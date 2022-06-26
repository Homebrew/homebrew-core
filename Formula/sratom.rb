class Sratom < Formula
  desc "Library for serializing LV2 atoms to/from RDF"
  homepage "https://drobilla.net/software/sratom.html"
  url "https://download.drobilla.net/sratom-0.6.10.tar.bz2"
  sha256 "e5951c0d7f0618672628295536a271d61c55ef0dab33ba9fc5767ed4db0a634d"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sratom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5d70a1c4699f7df3c12ea1f95645235d98677524ded264de6851ace4d61e2e61"
    sha256 cellar: :any,                 arm64_big_sur:  "dc78bd037b14f519ceab19fdd3ff343ab721486750ac7700e4a2da2e50d8fab2"
    sha256 cellar: :any,                 monterey:       "84bc80e17c73fb48b9dde7e30a7a23a2da276a9b0de645f3d7ed31fb09d4b2ec"
    sha256 cellar: :any,                 big_sur:        "d063496b5622cb4d5c5fb468c349e07f21bf258d389ba638115cda897ed73146"
    sha256 cellar: :any,                 catalina:       "5f71eb67b0b4a06d03ad5ce2a7b45bf0744b2b1b3301c1d9685cf3ccdcd609ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c5d244a598c32fbe980203c1370f5589d431d6e67793e9e98a665cae26e43aa"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf"
    system "python3", "./waf", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <sratom/sratom.h>

      int main()
      {
        return 0;
      }
    EOS
    lv2 = Formula["lv2"].opt_include
    serd = Formula["serd"].opt_include
    sord = Formula["sord"].opt_include
    system ENV.cc, "-I#{lv2}", "-I#{serd}/serd-0", "-I#{sord}/sord-0", "-I#{include}/sratom-0",
                   "-L#{lib}", "-lsratom-0", "test.c", "-o", "test"
    system "./test"
  end
end
