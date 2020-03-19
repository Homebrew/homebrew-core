class Radamsa < Formula
  desc "Test case generator for robustness testing (a.k.a. a \"fuzzer\")"
  homepage "https://gitlab.com/akihe/radamsa"
  url "https://gitlab.com/akihe/radamsa/-/archive/v0.6/radamsa-v0.6.tar.gz"
  sha256 "a68f11da7a559fceb695a7af7035384ecd2982d666c7c95ce74c849405450b5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "97fe42099e0b4278519ee560af5a38dd0cb5055e7542cd892d4c4f96d93960c5" => :catalina
    sha256 "a4d9d9e07ff76b8bb51333a04d645ea0213663dc635bdea890b1cffb7f2e6543" => :mojave
    sha256 "82d2231dcb25adb55f62690bd34d2b4b8978a3d22b956c0f0f2e20640d31c7a0" => :high_sierra
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

  def caveats
    <<~EOS
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
