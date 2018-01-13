class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxwidgets.org/"
  url "https://downloads.sourceforge.net/project/wxpython/wxPython/3.0.2.0/wxPython-src-3.0.2.0.tar.bz2"
  sha256 "d54129e5fbea4fb8091c87b2980760b72c22a386cb3b9dd2eebc928ef5e8df61"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "22b3a440740e2cd3f16014d468151d2b46004120e3a2e3d029e4e153a01bada0" => :high_sierra
    sha256 "0e095b7b61f71c23d36bcd795b9d0ce605adb073db1dc60978dfb0481306b345" => :sierra
    sha256 "9956afc649ebc394fbae40dd55d3ce367ab42abe6be43ef01c35c1c6d0a8e225" => :el_capitan
    sha256 "04d8dfeab6dbb7a1c099c8e866f35e6d5d528ea69ef283d556c545347882abe2" => :yosemite
    sha256 "41ec8003758d804b8c426ce654a87f2d9f4be3be40fcbcb3d5686e3ecabaddbc" => :mavericks
  end

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "wxmac"

  def install
    ENV["WXWIN"] = buildpath
    ENV.append_to_cflags "-arch #{MacOS.preferred_arch}"

    # wxPython is hardcoded to install headers in wx's prefix;
    # set it to use wxPython's prefix instead
    # See #47187.
    inreplace %w[wxPython/config.py wxPython/wx/build/config.py],
      "WXPREFIX +", "'#{prefix}' +"

    args = [
      "WXPORT=osx_cocoa",
      # Reference our wx-config
      "WX_CONFIG=#{Formula["wxmac"].opt_bin}/wx-config",
      # At this time Wxmac is installed Unicode only
      "UNICODE=1",
      # Some scripts (e.g. matplotlib) expect to `import wxversion`, which is
      # only available on a multiversion build.
      "INSTALL_MULTIVERSION=1",
      # OpenGL and stuff
      "BUILD_GLCANVAS=1",
      "BUILD_GIZMOS=1",
      "BUILD_STC=1",
    ]

    cd "wxPython" do
      system "python", "setup.py", "install", "--prefix=#{prefix}", *args
    end
  end

  test do
    output = shell_output("python -c 'import wx ; print wx.version()'")
    assert_match version.to_s, output
  end
end
