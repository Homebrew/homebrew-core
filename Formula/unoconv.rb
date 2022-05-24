class Unoconv < Formula
  include Language::Python::Shebang

  desc "Convert between any document format supported by OpenOffice"
  homepage "https://github.com/unoconv/unoconv"
  url "https://files.pythonhosted.org/packages/ab/40/b4cab1140087f3f07b2f6d7cb9ca1c14b9bdbb525d2d83a3b29c924fe9ae/unoconv-0.9.0.tar.gz"
  sha256 "308ebfd98e67d898834876348b27caf41470cd853fbe2681cc7dacd8fd5e6031"
  license "GPL-2.0"
  revision 3
  head "https://github.com/unoconv/unoconv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "632fc4da008b323aa3aeb15c6960b4e5c31b05f282db84616258881ade4bf0f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "632fc4da008b323aa3aeb15c6960b4e5c31b05f282db84616258881ade4bf0f8"
    sha256 cellar: :any_skip_relocation, monterey:       "b7e53457a5a8af631877af85382c03dbfc9b37ca410a287966a05d0fa89568fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7e53457a5a8af631877af85382c03dbfc9b37ca410a287966a05d0fa89568fb"
    sha256 cellar: :any_skip_relocation, catalina:       "b7e53457a5a8af631877af85382c03dbfc9b37ca410a287966a05d0fa89568fb"
    sha256 cellar: :any_skip_relocation, mojave:         "b7e53457a5a8af631877af85382c03dbfc9b37ca410a287966a05d0fa89568fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "632fc4da008b323aa3aeb15c6960b4e5c31b05f282db84616258881ade4bf0f8"
  end

  depends_on "python@3.10"

  def install
    rewrite_shebang detected_python_shebang, "unoconv"

    system "make", "install", "prefix=#{prefix}"
  end

  def caveats
    <<~EOS
      In order to use unoconv, a copy of LibreOffice between versions 3.6.0.1 - 4.3.x must be installed.
    EOS
  end

  test do
    assert_match "office installation", pipe_output("#{bin}/unoconv 2>&1")
  end
end
