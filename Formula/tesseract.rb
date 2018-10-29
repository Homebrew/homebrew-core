class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://github.com/tesseract-ocr/"
  url "https://github.com/tesseract-ocr/tesseract/archive/4.0.0.tar.gz"
  sha256 "a1f5422ca49a32e5f35c54dee5112b11b99928fc9f4ee6695cdc6768d69f61dd"

  bottle do
    sha256 "bb4b2eb8d8636c3f73bb692de94e833351ce505249f37e45a296ea633ffa9630" => :mojave
    sha256 "9fd259800c2c9b7c56f2f5b64be234c93019a0c00f8578cf82d45c28726e04ea" => :high_sierra
    sha256 "03335e88190bd7995f4ec721f84c54fa624733fde5af1086825292d287e8e7d6" => :sierra
    sha256 "421fa571e97ff211fb465eca39c4c289b57411867ebc1907818a0c8eac82d7dd" => :el_capitan
  end

  option "with-all-languages", "Install recognition data for all languages"
  option "with-training-tools", "Install OCR training tools"
  option "with-serial-num-pack", "Install serial number recognition pack"

  deprecated_option "all-languages" => "with-all-languages"

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "leptonica"
  depends_on "libtiff"

  if build.with? "training-tools"
    depends_on "libtool" => :build
    depends_on "icu4c"
    depends_on "glib"
    depends_on "cairo"
    depends_on "pango"
    depends_on :x11
  end

  resource "tessdata" do
    url "https://github.com/tesseract-ocr/tessdata_fast/archive/4.0.0-beta.1.tar.gz"
    sha256 "cfae2d9e15887a719c995baad70c01ad8f68c0361f5f0a4f46e4aa9ed8a47120"
  end

  resource "eng" do
    url "https://github.com/tesseract-ocr/tessdata_fast/raw/4.0.0-beta.1/eng.traineddata"
    sha256 "7d4322bd2a7749724879683fc3912cb542f19906c83bcc1a52132556427170b2"
  end

  resource "osd" do
    url "https://github.com/tesseract-ocr/tessdata_fast/raw/4.0.0-beta.1/osd.traineddata"
    sha256 "9cf5d576fcc47564f11265841e5ca839001e7e6f38ff7f7aacf46d15a96b00ff"
  end

  resource "snum" do
    url "https://github.com/USCDataScience/counterfeit-electronics-tesseract/raw/319a6eeacff181dad5c02f3e7a3aff804eaadeca/Training%20Tesseract/snum.traineddata"
    sha256 "36f772980ff17c66a767f584a0d80bf2302a1afa585c01a226c1863afcea1392"
  end

  needs :cxx11

  def install
    if build.with? "training-tools"
      icu4c = Formula["icu4c"]
      ENV.append "CFLAGS", "-I#{icu4c.opt_include}"
      ENV.append "LDFLAGS", "-L#{icu4c.opt_lib}"
    end

    # explicitly state leptonica header location, as the makefile defaults to /usr/local/include,
    # which doesn't work for non-default homebrew location
    ENV["LIBLEPT_HEADERSDIR"] = HOMEBREW_PREFIX/"include"

    ENV.cxx11

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"

    system "make", "install"
    if build.with? "serial-num-pack"
      resource("snum").stage { mv "snum.traineddata", share/"tessdata" }
    end
    if build.with? "training-tools"
      system "make", "training"
      system "make", "training-install"
    end
    if build.with? "all-languages"
      resource("tessdata").stage { mv Dir["*"], share/"tessdata" }
    else
      resource("eng").stage { mv "eng.traineddata", share/"tessdata" }
      resource("osd").stage { mv "osd.traineddata", share/"tessdata" }
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tesseract -v 2>&1")
  end
end
