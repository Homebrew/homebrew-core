class Wxpython < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/b0/4d/80d65c37ee60a479d338d27a2895fb15bbba27a3e6bb5b6d72bb28246e99/wxPython-4.1.1.tar.gz"
  sha256 "00e5e3180ac7f2852f342ad341d57c44e7e4326de0b550b9a5c4a8361b6c3528"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "9aed884ad2d17eadce20f6a004bdef1388b3f28a53dbe82751d110786723c336" => :big_sur
    sha256 "962dc706ef5e748da2f8ec188ce1fca50dcab98350b2254f50955ef8b118761e" => :catalina
    sha256 "342cee7f2cc885871b3471ef18e6ce026c93687a930fc7c658afbe21101f10ec" => :mojave
  end

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "python@3.9"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/2b/06/93bf1626ef36815010e971a5ce90f49919d84ab5d2fa310329f843a74bc1/Pillow-8.0.1.tar.gz"
    sha256 "11c5c6e9b02c9dac08af04f093eb5a2f84857df70a7d4a6a6ad461aca803fb9e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    # Fix build of included wxwidgets:
    # https://github.com/wxWidgets/Phoenix/issues/1247
    # https://github.com/Homebrew/homebrew-core/pull/58988
    inreplace "buildtools/build_wxwidgets.py" do |s|
      s.gsub! "#wxpy_configure_opts.append(\"--enable-monolithic\")",
              "wxpy_configure_opts.append(\"--disable-precomp-headers\")"
    end

    inreplace "wscript", "MACOSX_DEPLOYMENT_TARGET = \"10.6\"",
                         "MACOSX_DEPLOYMENT_TARGET = \"#{MacOS.version}\""

    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
        s.gsub! "openjpeg.h", "probably_not_a_header_called_this_eh.h"
        s.gsub! "xcb.h", "probably_not_a_header_called_this_eh.h"
        s.gsub! "ZLIB_ROOT = None",
          "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
        s.gsub! "JPEG_ROOT = None",
          "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None",
          "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
      end

      # avoid triggering "helpful" distutils code that doesn't recognize Xcode 7 .tbd stubs
      unless MacOS::CLT.installed?
        ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
      end
      venv.pip_install Pathname.pwd
    end

    res = resources.map(&:name).to_set - ["Pillow"]
    res.each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    output = shell_output("#{Formula["python@3.9"].opt_bin}/python3 -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end
