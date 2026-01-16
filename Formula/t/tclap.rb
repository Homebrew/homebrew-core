class Tclap < Formula
  desc "Templatized C++ command-line parser library"
  homepage "https://tclap.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/tclap/tclap-1.2.5.tar.gz"
  sha256 "bb649f76dae35e8d0dcba4b52acfd4e062d787e6a81b43f7a4b01275153165a6"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{url=.*?/tclap[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1067d4df91f61b3a6af2efd80c62b4359cc7f1f9088892ad9443d13be791bc0a"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    # Installer scripts have problems with parallel make
    ENV.deparallelize
    system "make", "install"
  end
end
