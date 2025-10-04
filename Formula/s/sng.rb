class Sng < Formula
  desc "Enable lossless editing of PNGs via a textual representation"
  homepage "https://sng.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sng/sng-1.1.1.tar.xz"
  sha256 "c9bdfb80f5a17db1aab9337baed64a8ebea5c0ddf82915c6887b8cfb87ece61e"
  license "Zlib"

  bottle do
    sha256                               arm64_tahoe:    "21a7abd0b2c11b995a816141ba9fd6681090a3bcea817ecd3d9947be6d36e02d"
    sha256 cellar: :any,                 arm64_sequoia:  "3fa5a7aa3bd864bc8f01ca6bd266e145565bef2edd9de53ae77acc866814ec83"
    sha256 cellar: :any,                 arm64_sonoma:   "da333412a3df6fc42a56de17352007250eed4c7240fe3fd245dc195c450fc711"
    sha256 cellar: :any,                 arm64_ventura:  "f6519f1b91d2139e045d7d0b116033d25c7630ff33c852074eeed4ad12b2a633"
    sha256 cellar: :any,                 arm64_monterey: "fb8a1cd97e77f84a4eddbd2c474bec4a442cd228fee2dacbd8d2f6de0f068c5e"
    sha256 cellar: :any,                 sonoma:         "168b65eff4e5fbca14f90676b704bbd0d114ca78fe82cf23ab5f03328af62fa4"
    sha256 cellar: :any,                 ventura:        "c3851e3ff4ae5a5dfe206f10604cb9406731d612fb55a7940b7e1e1b92492115"
    sha256 cellar: :any,                 monterey:       "596299bbce0f5c721dda34ec3e542291009850dfbc9b765ca8d33e4483926265"
    sha256                               arm64_linux:    "d3698cd1399af9fe64ce9f4cc8f68350b12383166dd7c528da05a1570e081324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d22fe6d563b5cbc5b8addbe26239cae3ba3fda6c0f1799fac4587af971a8a41b"
  end

  depends_on "libpng"
  depends_on "xorgrgb"

  def install
    # Fix RGBTXT ref to use Homebrew share path
    inreplace "Makefile", "/usr/share/X11/rgb.txt", "#{HOMEBREW_PREFIX}/share/X11/rgb.txt"

    system "make", "install", "DESTDIR=#{prefix}", "prefix=/", "CC=#{ENV.cc}"
  end

  test do
    cp test_fixtures("test.png"), "test.png"
    system bin/"sng", "test.png"
    assert_includes File.read("test.sng"), "width: 8; height: 8; bitdepth: 8;"
  end
end
