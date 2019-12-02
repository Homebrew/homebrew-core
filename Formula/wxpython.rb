class Wxpython < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for wxWidgets"
  homepage "https://www.wxwidgets.org/"
  url "https://files.pythonhosted.org/packages/b9/8b/31267dd6d026a082faed35ec8d97522c0236f2e083bf15aff64d982215e1/wxPython-4.0.7.post2.tar.gz"
  version "4.0.7.post2"
  sha256 "5a229e695b64f9864d30a5315e0c1e4ff5e02effede0a07f16e8d856737a0c4e"
  revision 1

  bottle do
    cellar :any
    sha256 "efbbe3dbd7c67ee29154ea478760322c8bfd78d6f47b3bd0cb7e60444393d5c0" => :catalina
    sha256 "ec81f44d7a30fd52f1fbdf2493a124c22e225cd1a4042489fcac5605599c9597" => :mojave
    sha256 "5a487d33cdd6493079b0e937a38565c7af94bcbe653f23d1b9e5411cb9539856" => :high_sierra
  end

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "python@3.8"

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/5b/bb/cdc8086db1f15d0664dd22a62c69613cdc00f1dd430b5b19df1bea83f2a3/Pillow-6.2.1.tar.gz"
    sha256 "bf4e972a88f8841d8fdc6db1a75e0f8d763e66e3754b03006cbc3854d89f1cb1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  # Fix build for 10.15 SDK (WebKit errors).
  # Fixed in 4.1.x.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/20da70f67040d40f8420bd7d543c875739261e24/wxpython/10.15-sdk.patch"
    sha256 "c54f2bb97532f483219c63a3c9e463d4aeda759bee2fff1f07820f3c752f68f1"
  end

  def install
    # Fix build of included wxwidgets
    # see https://github.com/wxWidgets/Phoenix/issues/1247
    inreplace "buildtools/build_wxwidgets.py",
              /^( +)(wxpy_configure_opts.append\("--disable-qtkit"\))/,
              "\\1\\2\n\\1wxpy_configure_opts.append(\"--disable-precomp-headers\")"

    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
        s.gsub! "openjpeg.h",
          "probably_not_a_header_called_this_eh.h"
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
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    output = shell_output("#{Formula["python@3.8"].opt_bin}/python3 -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end
