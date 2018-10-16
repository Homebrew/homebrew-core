class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxwidgets.org/"
  url "https://files.pythonhosted.org/packages/dd/31/bd55ab40e406a026a7fda0bb5eb61f466682544ae91ac26267c750f5e618/wxPython-4.0.3.tar.gz"
  sha256 "8d0dfc0146c24749ce00d575e35cc2826372e809d5bc4a57bde6c89031b59e75"

  bottle do
    cellar :any
    sha256 "e4d26479673fb7ada6601f4fc67525f843b13a68c03d15e3c793481398fcfef3" => :mojave
    sha256 "b3ed6dbe3c7b58b55d98025a7e2799137eeb78ec6260d18cd1b4e2057fb969f5" => :high_sierra
    sha256 "2ada5517b6cb456d65ad6849a65355893676d09f6c7a997b03325f0079a849f4" => :sierra
    sha256 "073777ade162a654d43d5866f69e6a857a7cedc677d7115200972e91261d9e0f" => :el_capitan
  end

  depends_on "python@2"
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
