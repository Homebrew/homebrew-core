class Wxpython < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/b0/4d/80d65c37ee60a479d338d27a2895fb15bbba27a3e6bb5b6d72bb28246e99/wxPython-4.1.1.tar.gz"
  sha256 "00e5e3180ac7f2852f342ad341d57c44e7e4326de0b550b9a5c4a8361b6c3528"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "016eaf4f384d47d051c635a72ebc35311264220acf8060f3e85ddc5487f99ef7"
    sha256 cellar: :any, big_sur:       "192ae16511d4d1b0830918a4b8cb693f5f8375a892fc771edb917c249dc8d3bf"
    sha256 cellar: :any, catalina:      "23ef89d5df837f5203b74513a0ae244ed461f67ff9759cee2d762a70b64ed003"
    sha256 cellar: :any, mojave:        "568c3fb2d698e9b823b6e9524f45d8057b39a0b248e81d46740496fea4d8791a"
  end

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "python@3.9"
  depends_on "tcl-tk"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/60/f0/dd2eb7911f948bf529f58f0c7931f6f6466f711bd6f1d81a69dc4edd4e2a/Pillow-8.1.2.tar.gz"
    sha256 "b07c660e014852d98a00a91adfbe25033898a9d90a8f39beb2437d22a203fc44"
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
        s.gsub! "openjpeg.h", "probably_not_a_header_called_this_eh.h"
        s.gsub! "xcb.h", "probably_not_a_header_called_this_eh.h"
        on_macos do
          sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
          s.gsub! "ZLIB_ROOT = None",
                  "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
        end
        on_linux do
          s.gsub! "ZLIB_ROOT = None",
                  "ZLIB_ROOT = ('#{Formula["zlib"].opt_prefix}/lib', '#{Formula["zlib"].opt_prefix}/include')"
        end
        s.gsub! "JPEG_ROOT = None",
          "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None",
          "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
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
