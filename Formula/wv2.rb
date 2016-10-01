class Wv2 < Formula
  desc "Programs for accessing Microsoft Word documents"
  homepage "http://wvware.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/wvware/wv2-0.4.2.tar.bz2"
  sha256 "9f2b6d3910cb0e29c9ff432f935a594ceec0101bca46ba2fc251aff251ee38dc"

  bottle do
    cellar :any
    sha256 "cd0856f53f0a143f5b0ea7dd61a0d23613db6de84538fa222e2819217a3ed3af" => :sierra
    sha256 "b3a07e873f69b90ed83d47ccedb6bc5fefcb5dc5c9ffd1ecfd38c03dd094afea" => :el_capitan
    sha256 "51ea82d6630ceee1739d0f252462ef8c4394ffaf0fb81b0a5141990f865f1427" => :yosemite
    sha256 "e91c85bf622d483194ab85c78c7b8131de245f54f64ee61a961c0b24d31545cc" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "libgsf"

  def install
    ENV.append "LDFLAGS", "-liconv -lgobject-2.0" # work around broken detection
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
