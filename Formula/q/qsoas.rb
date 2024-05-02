class Qsoas < Formula
  desc "Versatile software for data analysis"
  homepage "https://bip.cnrs.fr/groups/bip06/software/"
  url "https://bip.cnrs.fr/wp-content/uploads/qsoas/qsoas-3.3.tar.gz"
  sha256 "c5a701dfed23c682892479b43b92aac79a7db5ceb9ed6b6cd0a41129d2690492"
  license "GPL-2.0-only"

  livecheck do
    url "https://github.com/fourmond/QSoas.git"
    regex(/(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1a38da810ed778afab4910333154be9a7e9d023dbe6b31a1474f234195e71082"
    sha256 cellar: :any,                 arm64_ventura:  "3719d9bcc7efb9eb02ad8df0e5db43898c57cb85d6ccae3ec041c41c9516e20d"
    sha256 cellar: :any,                 arm64_monterey: "a6c01927415078bc9fa9502897cb3e1fc9ee697eb061cc65215622aa547d1e3c"
    sha256 cellar: :any,                 sonoma:         "8bde4f66b2c7038e53f5368ce5fadc708b3c026cad89fa4e3ae8e93c91eba57a"
    sha256 cellar: :any,                 ventura:        "e346084ec2da1a1a8b09655384c656e15b243634724ed3ad284da177f9001db2"
    sha256 cellar: :any,                 monterey:       "6d113519d854f6f1eec16a575aade4d729cfbec5185bf26dfba89a9c119fde47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aff2943602ababdef4e34fe307329ed45a6f499bfcebe8bd74c0abec6f834aa"
  end

  depends_on "bison" => :build
  depends_on "gsl"
  depends_on "mruby"
  depends_on "qt@5"

  uses_from_macos "ruby"

  fails_with gcc: "5"

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
