class Wxpython < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/b0/4d/80d65c37ee60a479d338d27a2895fb15bbba27a3e6bb5b6d72bb28246e99/wxPython-4.1.1.tar.gz"
  sha256 "00e5e3180ac7f2852f342ad341d57c44e7e4326de0b550b9a5c4a8361b6c3528"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  revision 2

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
  depends_on "pillow"
  depends_on "python@3.9"
  depends_on "six"
  depends_on "tcl-tk"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
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

    on_macos do
      sdk = MacOS.sdk_path_if_needed
      ENV.append_to_cflags "-I#{sdk}/usr/include" if sdk
    end
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    output = shell_output("#{Formula["python@3.9"].opt_bin}/python3 -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end
