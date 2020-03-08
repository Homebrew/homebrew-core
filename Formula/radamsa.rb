class Radamsa < Formula
  desc "Test case generator for robustness testing (a.k.a. a \"fuzzer\")"
  homepage "https://gitlab.com/akihe/radamsa"
  url "https://gitlab.com/akihe/radamsa/-/archive/v0.6/radamsa-v0.6.tar.gz"
  sha256 "a68f11da7a559fceb695a7af7035384ecd2982d666c7c95ce74c849405450b5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "564db494dea6ccbfaf2d8c3d084c14d45932874e5e324f0ecfde1c00414101e5" => :catalina
    sha256 "0d267d4e20c85e8da62cc4efadb2cf22386ecd9e87c23a0d1c46ff06a483bf4f" => :mojave
    sha256 "a971e3bf09f3854d724549a31b98854458b8c49cdfd88593fb14c380066d7bc1" => :high_sierra
    sha256 "d13369632654e12471ff029aa6c08f57e9572df60b9d5b18040ce341ca8b4b09" => :sierra
    sha256 "3b09d787e73444964136ab042bc458610eb4cf08f4ba015cbe7e1d13ab8509f5" => :el_capitan
  end

  resource "owl" do
    url "https://gitlab.com/owl-lisp/owl/uploads/0d0730b500976348d1e66b4a1756cdc3/ol-0.1.19.c.gz"
    sha256 "86917b9145cf3745ee8294c81fb822d17106698aa1d021916dfb2e0b8cfbb54d"
  end

  def install
    resource("owl").stage do
      buildpath.install "ol.c"
    end

    system "make"
    man1.install "doc/radamsa.1"
    prefix.install Dir["*"]
  end

  def caveats; <<~EOS
    The Radamsa binary has been installed.
    The Lisp source code has been copied to:
      #{prefix}/rad

    Tests can be run with:
      $ make .seal-of-quality

  EOS
  end

  test do
    system bin/"radamsa", "-V"
  end
end
