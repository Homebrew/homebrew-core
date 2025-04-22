class Qsoas < Formula
  desc "Versatile software for data analysis"
  homepage "https://bip.cnrs.fr/groups/bip06/software/"
  url "https://bip.cnrs.fr/wp-content/uploads/qsoas/qsoas-3.3.tar.gz"
  sha256 "c5a701dfed23c682892479b43b92aac79a7db5ceb9ed6b6cd0a41129d2690492"
  license "GPL-2.0-only"
  revision 1

  # The upstream server has an incomplete certificate chain, producing a
  # curl error on Linux (`(60) SSL certificate problem: unable to get local
  # issuer certificate`). This check can still work on macOS but we can't add
  # this formula to the autoump list until this is resolved.
  livecheck do
    url "https://bip.cnrs.fr/groups/bip06/software/downloads/"
    regex(/href=.*?qsoas[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "709468b0dea8e5700fadd12d2613a64af895204a3b7dfbf48da4fe6239ed7fb6"
    sha256 cellar: :any,                 arm64_sonoma:   "59cf34ad9e7db06d2e7e6d68dd60d12ba6f7a1b1818a322ac866f4895a0e3af8"
    sha256 cellar: :any,                 arm64_ventura:  "1aa8ad3b027fa61914688ca5857cd9ef030fa2d3e07a7555d06479f429d29691"
    sha256 cellar: :any,                 arm64_monterey: "25cd57d44b1e89044e1da640288bc33a511cadb10659137d2bb71f38b2d74b3d"
    sha256 cellar: :any,                 sonoma:         "8bd41179d0dcd078ac4731c5edc181352cdd6f639d49ee082b0cbab9a9c00f88"
    sha256 cellar: :any,                 ventura:        "6d3850245479bad8b493a9ffd52cca5e382dcc899fec0382dbcda96790e8f350"
    sha256 cellar: :any,                 monterey:       "751f9a7fda93b3193f2fb8c3118c79ec52bbaba6c95e0420b0ca981ac78cfdb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d99b2b0c412e82eb58102d3722c32b5629773334ac81996ee6d4e58f0dffef3"
  end

  depends_on "bison" => :build
  depends_on "gsl"
  depends_on "mruby"
  depends_on "qt@5"

  uses_from_macos "ruby"

  def install
    gsl = Formula["gsl"].opt_prefix
    qt5 = Formula["qt@5"].opt_prefix

    system "#{qt5}/bin/qmake", "MRUBY_DIR=#{Formula["mruby"].opt_prefix}",
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
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_match "mfit-linear-kinetic-system",
                 shell_output("#{bin}/QSoas --list-commands")
  end
end
