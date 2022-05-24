class Wxpython < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/b0/4d/80d65c37ee60a479d338d27a2895fb15bbba27a3e6bb5b6d72bb28246e99/wxPython-4.1.1.tar.gz"
  sha256 "00e5e3180ac7f2852f342ad341d57c44e7e4326de0b550b9a5c4a8361b6c3528"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  revision 2

  bottle do
    sha256 cellar: :any, arm64_monterey: "2b7a373364e93be90a1ef2304a2abe3507f7cbc632dd3a0a141eba7b82788675"
    sha256 cellar: :any, arm64_big_sur:  "d8fb50086a3047b2ff39d2747903ae591a87947f0dd84174e3da2ae1eb0f0171"
    sha256 cellar: :any, monterey:       "4b352f54a4570b5fb89a29566ba638889b18be31794243285f84aceb14b7ecbb"
    sha256 cellar: :any, big_sur:        "40e9e6c3cfe094b254d55e69e89ed38e8b48437efb49a641dc17ac2bbddf0df9"
    sha256 cellar: :any, catalina:       "67183e7560f2add598527db7eb0d30d4f4fe6e82b07db59bedd1cadeaedd1693"
    sha256 cellar: :any, mojave:         "8e06cb7727b4dd39b3ebd93f6691aa8147a1ee0fef47cdbfbece77d203f411f4"
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

    if OS.mac?
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
