class Sratom < Formula
  desc "Library for serializing LV2 atoms to/from RDF"
  homepage "https://drobilla.net/software/sratom.html"
  url "https://download.drobilla.net/sratom-0.6.14.tar.xz"
  sha256 "9982faf40db83aedd9b3850e499fecd6852b8b4ba6dede514013655cffaca1e6"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sratom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "b884d697b5ca163cb39767e13f7efa886e05019103fcf370d9f45929848d4097"
    sha256 cellar: :any, arm64_monterey: "4279011c330c294669c4a0269d588a2a13c94dd8572cbe5bd142a7e896f76b33"
    sha256 cellar: :any, arm64_big_sur:  "44288a39e0ff6b9744818a3cb288149f846ad5f53db803c8b0d833b0f912b3f9"
    sha256 cellar: :any, ventura:        "697d38170f40d06ad287a1df04319f77720820eda51beb1b653562f78a1f4758"
    sha256 cellar: :any, monterey:       "be71b80a11c1bb0e0abd54ec1e6823b962cedeb9be33da38ed880251ce4ad3ee"
    sha256 cellar: :any, big_sur:        "a9080fe9fb2599855f5b512caab3cfdce9c40f3c285597de3899c67dfe8cb2d0"
    sha256 cellar: :any, catalina:       "d6514a036efc5cd3820bcd686aaea2ab4fc9d85071dc32f09d702cf48d6c9004"
    sha256               x86_64_linux:   "1a5c19504309b0a88bf93ca6c4e4176438af55b2bb638df0d54e31614cc811cb"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dtests=disabled", ".."
      system "ninja"
      system "ninja", "install"
    end
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
