class Qsoas < Formula
  desc "Versatile software for data analysis"
  homepage "https://bip.cnrs.fr/groups/bip06/software/"
  url "https://bip.cnrs.fr/wp-content/uploads/qsoas/qsoas-3.1.tar.gz"
  sha256 "0c8f013fef6746b833dc59477aa476eeb10f53c9dcb2e0f960c86122892f6c15"
  license "GPL-2.0-only"

  livecheck do
    url "https://github.com/fourmond/QSoas.git"
    regex(/(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "49f6b58cb6d42a6ccae90d8e04eb6dccc0a57ff0bb11e192bdd6d31fd37c80f1"
    sha256 cellar: :any,                 arm64_big_sur:  "fd49438c3fc4171cbeef6e1a9d1366be8782e6417adcd4333566c479d77e6644"
    sha256 cellar: :any,                 monterey:       "51804fe94d9b83e9c203a3a9f7ec9ec8f3a187fb664723e3abdf89b339d0be79"
    sha256 cellar: :any,                 big_sur:        "0df6dacf4c5af50ca05e7fa848ea85478e67f8e6b1f811a99a3b2f7697b45949"
    sha256 cellar: :any,                 catalina:       "374f332ee48449e930b83e2b8b6149546029893fdb049b9e85366b732a79f21e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5537096857b3863d160c8c051e59cb2d86c932a37103b542e974aeeb62cf99f4"
  end

  depends_on "bison" => :build
  depends_on "gsl"
  depends_on "qt@5"

  uses_from_macos "ruby"

  fails_with gcc: "5"

  # Needs mruby 2, see https://github.com/fourmond/QSoas/issues/2
  resource "mruby2" do
    url "https://github.com/mruby/mruby/archive/2.1.2.tar.gz"
    sha256 "4dc0017e36d15e81dc85953afb2a643ba2571574748db0d8ede002cefbba053b"
  end

  def install
    resource("mruby2").stage do
      inreplace "build_config.rb", /default/, "full-core"
      system "make"

      cd "build/host/" do
        libexec.install %w[bin lib mrbgems mrblib]
      end

      libexec.install "include"
    end

    gsl = Formula["gsl"].opt_prefix
    qt5 = Formula["qt@5"].opt_prefix

    system "#{qt5}/bin/qmake", "MRUBY_DIR=#{libexec}", "GSL_DIR=#{gsl}/include",
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
