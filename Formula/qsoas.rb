class Qsoas < Formula
  desc "Versatile software for data analysis"
  homepage "https://bip.cnrs.fr/groups/bip06/software/"
  url "https://bip.cnrs.fr/wp-content/uploads/qsoas/qsoas-3.0.tar.gz"
  sha256 "54b54f54363f69a9845b3e9aa4da7dae9ceb7bb0f3ed59ba92ffa3b408163850"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url "https://github.com/fourmond/QSoas.git"
    regex(/(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "13d591fadbb428a0fbef8090685b5d93489a5d1ea8b7414c1353ba2ff6ba0ecb"
    sha256 cellar: :any, arm64_big_sur:  "025ebba3b2548d8bff4df22b14531d39ce5f43b21fb0a8ce726d0ac29f30f7fb"
    sha256 cellar: :any, monterey:       "2f98550e8aa3740ef339886368cc4934a75418a4e6dfae36c72993d8e74dfaa4"
    sha256 cellar: :any, big_sur:        "36f444f910ab011d56e9d109c9e1526be465efec24be4ecccf75f1232e9d115e"
    sha256 cellar: :any, catalina:       "c6fac9f46c8365e23ecc2dee06c29272724039c58ebe347339da1bee9eeae149"
  end

  depends_on "bison" => :build
  depends_on "gsl"
  depends_on "qt@5"

  uses_from_macos "ruby"

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

    prefix.install "QSoas.app"
    bin.write_exec_script "#{prefix}/QSoas.app/Contents/MacOS/QSoas"
  end

  test do
    assert_match "mfit-linear-kinetic-system",
                 shell_output("#{bin}/QSoas --list-commands")
  end
end
