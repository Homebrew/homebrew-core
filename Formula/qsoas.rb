class Qsoas < Formula
  desc "Versatile software for data analysis"
  homepage "http://bip.cnrs-mrs.fr/bip06/qsoas/"
  url "http://bip.cnrs-mrs.fr/bip06/qsoas/downloads/qsoas-2.2.0.tar.gz"
  sha256 "acefcbb4286a6e0bf96353f924115d04a77d241962ceda890508bca19ee3b4f6"
  revision 1

  bottle do
    cellar :any
    sha256 "001b054635b8e50373f9e3cb2e0b377f558662697f096fdb388c2e3fa066d54d" => :mojave
    sha256 "51791b6babc31ea8852e7e5c5c607cd961af8513ef35dd0a04a56766ed0f1200" => :high_sierra
    sha256 "bbc71d9440e401a3bfd52f164b709c08c5d11300cdcef056728ca8dd08435d38" => :sierra
  end

  depends_on "gsl"
  depends_on "mruby"
  depends_on "qt"

  patch do
    url "https://github.com/fourmond/QSoas/compare/2.2.0...release.diff?full_index=1"
    sha256 "06b122580b6da169730ded812290eb53e1a6ff36d6c20ab9930c3e50b7a79b60"
  end

  def install
    gsl = Formula["gsl"].opt_prefix
    mruby = Formula["mruby"].opt_prefix

    system "qmake", "MRUBY_DIR=#{mruby}", "GSL_DIR=#{gsl}/include",
                    "QMAKE_LFLAGS=-L#{mruby}/lib -L#{gsl}/lib"
    system "make"

    prefix.install "QSoas.app"
    bin.write_exec_script "#{prefix}/QSoas.app/Contents/MacOS/QSoas"
  end

  test do
    assert_match "mfit-linear-kinetic-system",
                 shell_output("#{bin}/QSoas --list-commands")
  end
end
