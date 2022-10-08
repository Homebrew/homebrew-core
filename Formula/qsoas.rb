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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "a50195188c580b9114e768ea31d8494ea517c4f2206b741029cc7fb9f46e7f4d"
    sha256 cellar: :any,                 arm64_big_sur:  "6c63199fb6691a9dd48e42469dd194f9869e45919a2f44f48a0f808f26a27ee1"
    sha256 cellar: :any,                 monterey:       "ac5d93133c50ad22e5fbd4846254fc008a7950c91b6b549967439af172dad87a"
    sha256 cellar: :any,                 big_sur:        "7e96786652a24b9ecbec0dec30bb3242a193b810d00d2d11ef57ac841195c761"
    sha256 cellar: :any,                 catalina:       "07a56bd5f057f5344516298230e0bb3b1e4c83ed374e1ca07dd109137508783e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b454039a29528d8fcb8cc6230530b803ab5624f1e7602c77205b01623d8c6427"
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
