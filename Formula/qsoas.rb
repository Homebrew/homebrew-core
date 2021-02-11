class Qsoas < Formula
  desc "Versatile software for data analysis"
  homepage "https://bip.cnrs.fr/groups/bip06/software/"
  url "https://bip.cnrs.fr/wp-content/uploads/qsoas/qsoas-3.0.tar.gz"
  sha256 "54b54f54363f69a9845b3e9aa4da7dae9ceb7bb0f3ed59ba92ffa3b408163850"
  license "GPL-2.0-only"

  livecheck do
    url "https://github.com/fourmond/QSoas.git"
    regex(/(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, catalina:    "0792b9b5e0b57820e9bc0865815e2daef3de3a97a625f06080877bebcffd1d7f"
    sha256 cellar: :any, mojave:      "001b054635b8e50373f9e3cb2e0b377f558662697f096fdb388c2e3fa066d54d"
    sha256 cellar: :any, high_sierra: "51791b6babc31ea8852e7e5c5c607cd961af8513ef35dd0a04a56766ed0f1200"
    sha256 cellar: :any, sierra:      "bbc71d9440e401a3bfd52f164b709c08c5d11300cdcef056728ca8dd08435d38"
  end

  depends_on "gsl"
  depends_on "mruby"
  depends_on "qt@5"

  def install
    gsl = Formula["gsl"].opt_prefix
    mruby = Formula["mruby"].opt_prefix
    qt5 = Formula["qt@5"].opt_prefix

    system "#{qt5}/bin/qmake", "MRUBY_DIR=#{mruby}", "GSL_DIR=#{gsl}/include",
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
