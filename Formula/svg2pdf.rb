class Svg2pdf < Formula
  desc "Renders SVG images to a PDF file (using Cairo)"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/svg2pdf-0.1.3.tar.gz"
  sha256 "854a870722a9d7f6262881e304a0b5e08a1c61cecb16c23a8a2f42f2b6a9406b"
  license "LGPL-2.1"
  revision 2

  livecheck do
    url "https://cairographics.org/snapshots/"
    regex(/href=.*?svg2pdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dd7230495881424c8a87dab9fe1e076df3cb0d714a93070ae8239314bcb5ca13"
    sha256 cellar: :any,                 arm64_monterey: "059061cd7c6f0466c2ae93003220d0a4559659393d8c4d519511a08410dc9a09"
    sha256 cellar: :any,                 arm64_big_sur:  "74f2c15d9de7f737aedc70ff715b238fb3482ca67483e29547a0d608c2f78db6"
    sha256 cellar: :any,                 ventura:        "2abc4498f4ee621d30d07293f7676961c3eece3a557faa0c0893e9ef7600cae1"
    sha256 cellar: :any,                 monterey:       "944236f1828f69922b87cd63b55f5cff0e20f3a565ceb977aaf0bad2f72374e6"
    sha256 cellar: :any,                 big_sur:        "b1275e6db5e5512c89394381f1e3e6649225e656df36412dc87e28cd3bd9130f"
    sha256 cellar: :any,                 catalina:       "806321a4363be84920038c530898354f98dd8e852ec14e963b7959b2a1ff28f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da8f29a9fa362e43d754a326cf274898b7ee24dda8591b4169cfb8e31b6a51a4"
  end

  depends_on "pkg-config" => :build
  depends_on "libsvg-cairo"

  resource("svg.svg") do
    url "https://raw.githubusercontent.com/mathiasbynens/small/master/svg.svg"
    sha256 "900fbe934249ad120004bd24adf66aad8817d89586273c0cc50e187bddebb601"
  end

  def install
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    unless OS.mac?
      inreplace "src/Makefile.in", "$(svg2pdf_LDFLAGS) $(svg2pdf_OBJECTS)",
                                   "$(svg2pdf_OBJECTS) $(svg2pdf_LDFLAGS)"
    end

    system "./configure", *std_configure_args, "--mandir=#{man}"
    system "make", "install"
  end

  test do
    resource("svg.svg").stage do
      system "#{bin}/svg2pdf", "svg.svg", "test.pdf"
      assert_predicate Pathname.pwd/"test.pdf", :exist?
    end
  end
end
