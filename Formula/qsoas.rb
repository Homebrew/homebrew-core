class Qsoas < Formula
  desc "Versatile software for data analysis"
  homepage "http://bip.cnrs-mrs.fr/bip06/qsoas/"
  url "http://bip.cnrs-mrs.fr/bip06/qsoas/downloads/qsoas-2.2.0.tar.gz"
  sha256 "acefcbb4286a6e0bf96353f924115d04a77d241962ceda890508bca19ee3b4f6"

  bottle do
    sha256 "95be99b152857cd84d23c847d66ec90ed5dbccb245032aeaa63f9cb1c000c72f" => :mojave
    sha256 "2864c431780caeff59926d6c51d2a5a925814b33d172b03065f8713d2b9d49ee" => :high_sierra
    sha256 "8fd2e6ddb2224a9b00218572dc9e6f74ae45df730e468250b8674cf116975471" => :sierra
    sha256 "34be95fb5a3919dad8d41579e1822bd9ba46a553c96b4f8f90268ef3491e228a" => :el_capitan
  end

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
