class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.7.2.tar.gz"
  sha256 "09a540fe0be65f6cccb08a1f9f4dcfde03b29654c99aaf8adf9dcfcd1df1bfe5"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "7b40a92c4b0a7d90bd733c11ec76fc655b63833ebcc893b32e13b3c725f87d7d"
    sha256 arm64_big_sur:  "81ea6e75afe8fd5987c267e83d72397b9db0d43046773b0052e2011bc7d25dd3"
    sha256 monterey:       "135364e851b0e44f972a4f07caa76968e0826af84d31ac084610289e3147e209"
    sha256 big_sur:        "687c679eee855ce23026629aff5fc79cb1fd6d142b3c84d13fca57c3869d323c"
    sha256 catalina:       "77f898d9e20f8f1b620f2d98ca8c0e78feba55d09939dadc1a870a11f08b6009"
    sha256 x86_64_linux:   "f944f7c744ffba5210d89a77729bbbe0d37a710e6f121f87054a17954b298867"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
