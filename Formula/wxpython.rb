class Wxpython < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for wxWidgets"
  homepage "https://www.wxwidgets.org/"
  url "https://files.pythonhosted.org/packages/9a/a1/9c081e04798eb134b63def3db121a6e4436e1d84e76692503deef8e75423/wxPython-4.0.6.tar.gz"
  sha256 "35cc8ae9dd5246e2c9861bb796026bbcb9fb083e4d49650f776622171ecdab37"

  bottle do
    cellar :any
    sha256 "2df58a8f1ccba9acc4e7bb7d17cdfaf14a29acd59d8bcab15d6de0bf2784fb7c" => :mojave
    sha256 "b206e93c7820402551b7c9648aa64f7ca3b910162c5724ae98b22ce7c2ffa658" => :high_sierra
    sha256 "9472c06ce95355a9afb82aaa85eaf12b04e823d718064961a8c3b85520a55c76" => :sierra
  end

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "python"

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/81/1a/6b2971adc1bca55b9a53ed1efa372acff7e8b9913982a396f3fa046efaf8/Pillow-6.0.0.tar.gz"
    sha256 "809c0a2ce9032cbcd7b5313f71af4bdc5c8c771cb86eb7559afd954cab82ebb5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  # Fix build with recent macOS versions (remove with next version)
  patch do
    url "https://github.com/wxWidgets/Phoenix/commit/dcb06f6f.diff?full_index=1"
    sha256 "efb0cf73be0f677967d98f8bb3af4885bd164882c2c930fb8abf23e5bdddc9fa"
  end

  # Do not require pathlib2 dependency (remove with next version)
  patch do
    url "https://github.com/wxWidgets/Phoenix/commit/2c4f9cb2.diff?full_index=1"
    sha256 "1ec14aaf175ec64ccc00174c3bae416dc059c4c4138215bc4370377bfd15130b"
  end

  def install
    # Fix build of included wxwidgets
    # see https://github.com/wxWidgets/Phoenix/issues/1247
    inreplace "buildtools/build_wxwidgets.py",
              "#wxpy_configure_opts.append(\"--enable-monolithic\")",
              "wxpy_configure_opts.append(\"--disable-precomp-headers\")"

    venv = virtualenv_create(libexec, "python3")

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
        s.gsub! "openjpeg.h", "probably_not_a_header_called_this_eh.h"
        s.gsub! "ZLIB_ROOT = None", "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
        s.gsub! "JPEG_ROOT = None", "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None", "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
      end

      # avoid triggering "helpful" distutils code that doesn't recognize Xcode 7 .tbd stubs
      ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers" unless MacOS::CLT.installed?
      venv.pip_install Pathname.pwd
    end

    res = resources.map(&:name).to_set - ["Pillow"]
    res.each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
  end

  test do
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    output = shell_output("python3 -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end
