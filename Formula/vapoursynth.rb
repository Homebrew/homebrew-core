class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R40.tar.gz"
  sha256 "a5e4260abff95c4bf33cc7ff3203e8001f7b3be7bb5ccc3a6fc2b18523823e50"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 "395ceeb23551cfe36b1fcacf15c3dce35697373b287caf59e6f1918b874e6c3a" => :high_sierra
    sha256 "223896633f0a26a4fa6281fb47ce3339071b5e2eb00b69ce8add6988984d282b" => :sierra
    sha256 "f1fce97b0975d8e8b9651e02f89e762958da784ff5cd2600f13e943fc9a23851" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "nasm" => :build

  depends_on "libass"
  depends_on :macos => :el_capitan # due to zimg dependency
  depends_on :python3
  depends_on "tesseract"
  depends_on "zimg"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/10/32/21873ff231e069f860098b1602bb9e3ae2806d2f73ba661b5d806f200243/Cython-0.27.1.tar.gz"
    sha256 "e6840a2ba2704f4ffb40e454c36f73aeb440a4005453ee8d7ff6a00d812ba176"
  end

  def install
    venv = virtualenv_create(buildpath/"cython", "python3")
    venv.pip_install "Cython"
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-cython=#{buildpath}/cython/bin/cython"
    system "make", "install"
  end

  test do
    py3 = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{py3}/site-packages"
    system "python3", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
