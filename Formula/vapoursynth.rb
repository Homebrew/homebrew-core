class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R33.1.tar.gz"
  sha256 "8c448e67bccbb56af96ed0e6ba65f0ec60bc33482efd0534f5b4614fb8920494"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 "39a5933621f0656e858ba8352088f819bd9b4f4a048936caae682f39a19b0da7" => :sierra
    sha256 "3c7f28c274b0ba202f0f2a455c689621fa847d04af3ca5f1ada3fa7480f4cf19" => :el_capitan
    sha256 "e452d48c3a5fae1d64ac1ef210bbf779c13df47126573f142fa2481ad2c5ac9c" => :yosemite
    sha256 "8a019dc33d5697b8a57248be2996ac255fc4d21e3ba7c90c956f7806bf0b570f" => :mavericks
  end

  needs :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  depends_on "libass"
  depends_on :python3
  depends_on "tesseract"
  depends_on "zimg"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/b1/51/bd5ef7dff3ae02a2c6047aa18d3d06df2fb8a40b00e938e7ea2f75544cac/Cython-0.24.tar.gz"
    sha256 "6de44d8c482128efc12334641347a9c3e5098d807dd3c69e867fa8f84ec2a3f1"
  end

  def install
    version = Language::Python.major_minor_version("python3")
    py3_site_packages = libexec/"lib/python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", py3_site_packages

    resource("Cython").stage do
      system "python3", *Language::Python.setup_install_args(libexec)
    end
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    ENV.prepend_create_path "PATH", libexec/"bin"

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"vspipe", "--version"
    system "python3", "-c", "import vapoursynth"
  end
end
