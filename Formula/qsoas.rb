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
    sha256 cellar: :any, big_sur:  "9126a690ef49c7c0a39373798497ee459a425aa934db742149bd6795bb66e462"
    sha256 cellar: :any, catalina: "a31e3325767d38980ddac83ad1110b6ddcd6055c27c22f09b388eb32427cff78"
    sha256 cellar: :any, mojave:   "fc0e4157d6dd55ba6563e56c11af2da9106c88daadd2e94e809f4300fec5ad66"
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
