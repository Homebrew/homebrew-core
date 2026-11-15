class Qsoas < Formula
  desc "Versatile software for data analysis"
  homepage "https://bip.cnrs.fr/groups/bip06/software/"
  url "https://bip.cnrs.fr/wp-content/uploads/qsoas/qsoas-3.3.tar.gz"
  mirror "https://web.archive.org/web/20250919084255/https://bip.cnrs.fr/wp-content/uploads/qsoas/qsoas-3.3.tar.gz"
  sha256 "c5a701dfed23c682892479b43b92aac79a7db5ceb9ed6b6cd0a41129d2690492"
  license "GPL-2.0-or-later"
  revision 1

  # The upstream server has an incomplete certificate chain, producing a
  # curl error on Linux (`(60) SSL certificate problem: unable to get local
  # issuer certificate`). This check can still work on macOS but we can't add
  # this formula to the autoump list until this is resolved.
  livecheck do
    url "https://bip.cnrs.fr/groups/bip06/software/downloads/"
    regex(/href=.*?qsoas[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "42dc3f046f8b07e9a2c660ad2fab02624b0806be8d6b930a57d4f05963b9dda8"
    sha256 cellar: :any, arm64_tahoe:       "19888b18f9cde40f6b7b7f366345da60612d94d09134fd0480fd05f4e06f201d"
    sha256 cellar: :any, arm64_sequoia:     "08dd560419d14904c9dc2f91e60da338774d3c88daa8c8f820b2e2d46e6377e1"
    sha256 cellar: :any, arm64_linux:       "dd3f06c497efa8d1d9fa394537619e27901953ef15928f8d1f7e4339c2ea62cc"
    sha256 cellar: :any, x86_64_linux:      "fa19766dfaaf2775fcdecc9b5d5e40d861849df7fb87eeba9b6c79cbfc4ba8aa"
  end

  # Can undeprecate if new release with Qt 6 support is available.
  deprecate! date: "2026-05-19", because: "needs end-of-life Qt 5"
  disable! date: "2026-11-19", because: "needs end-of-life Qt 5"

  depends_on "bison" => :build
  depends_on "gsl"
  depends_on "qt@5"
  depends_on "readline"

  uses_from_macos "ruby"

  resource "mruby" do
    url "https://github.com/mruby/mruby/archive/refs/tags/3.4.0.tar.gz"
    sha256 "183711c7a26d932b5342e64860d16953f1cc6518d07b2c30a02937fb362563f8"
  end

  def install
    resource("mruby").stage do
      system "make"

      cd "build/host" do
        libexec.install %w[bin lib mrbgems mrblib]
      end
      libexec.install "include"
    end

    # Workaround for MRuby 3.4.0 and to avoid C standard passed to C++ compiler
    # Issue ref: https://github.com/fourmond/QSoas/issues/5
    inreplace "src/mruby.cc", "(OP_LOADI,", "(OP_LOADI8,"
    inreplace "QSoas.pro", "mruby-config --cflags)", "mruby-config --cxxflags)"

    gsl = formula_opt_prefix("gsl")
    qt5 = formula_opt_prefix("qt@5")

    system "#{qt5}/bin/qmake", "MRUBY_DIR=#{libexec}",
                               "GSL_DIR=#{gsl}/include",
                               "QMAKE_LFLAGS=-L#{libexec}/lib -L#{gsl}/lib"
    system "make"

    if OS.mac?
      prefix.install "QSoas.app"
      bin.write_exec_script "#{prefix}/QSoas.app/Contents/MacOS/QSoas"
    else
      bin.install "QSoas"
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal"
    assert_match "mfit-linear-kinetic-system",
                 shell_output("#{bin}/QSoas --list-commands")
  end
end
