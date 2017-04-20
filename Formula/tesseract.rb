class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://github.com/tesseract-ocr/"
  url "https://github.com/tesseract-ocr/tesseract/archive/3.05.00.tar.gz"
  sha256 "3fe83e06d0f73b39f6e92ed9fc7ccba3ef734877b76aa5ddaaa778fac095d996"
  revision 1

  bottle do
    sha256 "45167af1ab8944f17e1a978d9c7d397c505d0557a3ddecd4561a8e9553884e07" => :sierra
    sha256 "a6029be869ded018b10584b781e3ecc3b4ad0abaf7b31d354c92d102a26dbb18" => :el_capitan
    sha256 "f726ac1c5c03d6ba4f6b4ee1c54e062985526c754e1a15d06b59be16d52fd6b8" => :yosemite
  end

  head do
    url "https://github.com/tesseract-ocr/tesseract.git"
    resource "tessdata-head" do
      url "https://github.com/tesseract-ocr/tessdata.git"
    end
  end

  option "with-all-languages", "Install recognition data for all languages"
  option "with-training-tools", "Install OCR training tools"
  option "with-opencl", "Enable OpenCL support"
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

  needs :cxx11

  resource "tessdata" do
    url "https://github.com/tesseract-ocr/tessdata/archive/3.04.00.tar.gz"
    sha256 "5dcb37198336b6953843b461ee535df1401b41008d550fc9e43d0edabca7adb1"
  end

  resource "eng" do
    url "https://github.com/tesseract-ocr/tessdata/raw/3.04.00/eng.traineddata"
    sha256 "c0515c9f1e0c79e1069fcc05c2b2f6a6841fb5e1082d695db160333c1154f06d"
  end

  resource "osd" do
    url "https://github.com/tesseract-ocr/tessdata/raw/3.04.00/osd.traineddata"
    sha256 "9cf5d576fcc47564f11265841e5ca839001e7e6f38ff7f7aacf46d15a96b00ff"
  end

  resource "snum" do
    url "https://github.com/USCDataScience/counterfeit-electronics-tesseract/raw/319a6eeacff181dad5c02f3e7a3aff804eaadeca/Training%20Tesseract/snum.traineddata"
    sha256 "36f772980ff17c66a767f584a0d80bf2302a1afa585c01a226c1863afcea1392"
  end

  # remove on next release, > 3.05.00
  # upstream fix for building with OpenCL enabled
  # https://github.com/tesseract-ocr/tesseract/pull/814
  patch do
    url "https://github.com/tesseract-ocr/tesseract/commit/b18cad4.patch"
    sha256 "10c59baa54c3406fcd03f36cd0f1e3cc2ba150f082d14f919274a541b3cff7b2"
  end

  def install
    if build.head?
      # ld: symbol(s) not found for _clSetKernelArg and other symbols
      # Regression caused by https://github.com/tesseract-ocr/tesseract/commit/b1c921b
      # Reported 13 Sep 2016 https://github.com/tesseract-ocr/tesseract/issues/426
      inreplace "api/Makefile.am", "$(GENERIC_LIBRARY_VERSION) -no-undefined",
                                   "$(GENERIC_LIBRARY_VERSION)"
    end

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

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--enable-opencl" if build.with? "opencl"
    system "./configure", *args

    system "make", "install"
    if build.with? "serial-num-pack"
      resource("snum").stage { mv "snum.traineddata", share/"tessdata" }
    end
    if build.with? "training-tools"
      system "make", "training"
      system "make", "training-install"
    end
    if build.head?
      resource("tessdata-head").stage { mv Dir["*"], share/"tessdata" }
    elsif build.with? "all-languages"
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
