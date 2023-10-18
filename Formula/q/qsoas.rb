class Qsoas < Formula
  desc "Versatile software for data analysis"
  homepage "https://bip.cnrs.fr/groups/bip06/software/"
  url "https://bip.cnrs.fr/wp-content/uploads/qsoas/qsoas-3.2.tar.gz"
  sha256 "0cd0e3b0d77666797a1447b5ff7cf9ed35b53efd091fa7525fad4913c896de79"
  license "GPL-2.0-only"

  livecheck do
    url "https://github.com/fourmond/QSoas.git"
    regex(/(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d29b2f65c9aa182b5b27c7c1640674862df244be75b51b75ac2b446a7c50d607"
    sha256 cellar: :any,                 arm64_ventura:  "438d7f9af6814f1691bb359bfaaac693251f1b16755a37f20a172a99e4a05e26"
    sha256 cellar: :any,                 arm64_monterey: "46058c026ed1f265beefb389ae198a3ff6a9441e413cc291d8b4eba87b66469a"
    sha256 cellar: :any,                 arm64_big_sur:  "f80cb135a5650e23fc09b9c2bd9a8f09f13726aa7bcf3c86b7712acb48572df7"
    sha256 cellar: :any,                 sonoma:         "e1f6279b2229fcf859379e9f5ab39e15630be109505fb3e258a3580edc6e018a"
    sha256 cellar: :any,                 ventura:        "08901a171960dffc48598688ac87facc4d695d11862e92c18d03c0b912d0c8cc"
    sha256 cellar: :any,                 monterey:       "834ba1207a00845d5c27a8aea184a31002f32e3be6e3850d329fe16ff94fc7a1"
    sha256 cellar: :any,                 big_sur:        "bc6e5e7f128f623b77b6a535c90c879fc7352def13d84f8684944553824837a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02be44ecc8f76fb4d46f0d1cf8feffaa3d9b4cd3a50c712514b1a6929b70a393"
  end

  depends_on "bison" => :build
  depends_on "gsl"
  depends_on "qt@5"

  uses_from_macos "ruby"

  fails_with gcc: "5"

  # Needs mruby 2, see https://github.com/fourmond/QSoas/issues/4
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
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_match "mfit-linear-kinetic-system",
                 shell_output("#{bin}/QSoas --list-commands")
  end
end
