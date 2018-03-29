class Qsoas < Formula
  desc "Free advanced MasterMind clone"
  homepage "http://bip.cnrs-mrs.fr/bip06/qsoas/"
  url "http://bip.cnrs-mrs.fr/bip06/qsoas/downloads/qsoas-2.2.0.tar.gz"
  sha256 "acefcbb4286a6e0bf96353f924115d04a77d241962ceda890508bca19ee3b4f6"

  depends_on "gsl"
  depends_on "mruby"
  depends_on "qt"

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
