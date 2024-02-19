class Rpm2cpio < Formula
  desc "Tool to convert RPM package to CPIO archive"
  homepage "https://svnweb.freebsd.org/ports/head/archivers/rpm2cpio/"
  url "https://svnweb.freebsd.org/ports/head/archivers/rpm2cpio/files/rpm2cpio?revision=408590&view=co"
  version "1.4"
  sha256 "2841bacdadde2a9225ca387c52259d6007762815468f621253ebb537d6636a00"
  license "BSD-2-Clause"

  livecheck do
    url "https://svnweb.freebsd.org/ports/head/archivers/rpm2cpio/Makefile?view=co"
    regex(/^PORTVERSION=\s*?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e5bef9c5fde93319786a6082987ace54ad0ff52448861e2f1f2936c50d4096e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e95d0ee3055e63c6df341cdf6ab8d1c9b30001bf0c959bf765fa934ebc38fc3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d2bd622fc1b3cc2972511bbd789a6fb3663db803fdc3873357e060d593a5f49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86cbd26b2d25b70227c772d458ccd327ed236e065623adf840046caf71234a35"
    sha256 cellar: :any_skip_relocation, sonoma:         "56180c339efdef6e8b39111beb0830ded2875998650fc637696954594fcdd702"
    sha256 cellar: :any_skip_relocation, ventura:        "ccc67d1062ebaefefb76a57cca84f018503010fa7ef775e2a7cc51eded30e4cd"
    sha256 cellar: :any_skip_relocation, monterey:       "bf51b9307a69adeba4b3dc3379eb948a45c9b0f93fbfac42d6277bf5c5962de1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c469533235ec43ab54f3c26f610d637f65ab2fee070116c58882b2f9996acd11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59182d4cbea8af7773a1315e6c707ddece3d511b5ca7ec6866f893b1d172b9ae"
  end

  depends_on "libarchive"
  depends_on "xz"

  on_linux do
    conflicts_with "rpm", because: "both install `rpm2cpio` binaries"
  end

  def install
    tar = OS.mac? ? "tar" : "bsdtar"
    inreplace "rpm2cpio", "tar", Formula["libarchive"].bin/tar
    bin.install "rpm2cpio"
  end

  test do
    resource "homebrew-testdata" do
      url "https://rpmfind.net/linux/fedora/linux/releases/39/Everything/x86_64/os/Packages/h/hello-2.12.1-2.fc39.x86_64.rpm"
      sha256 "10f9944f95ca54f224133cffab1cfab0c40e3adb64e4190d3d9e8f9dbed680f9"
    end

    testpath.install resource "homebrew-testdata"
    system bin/"rpm2cpio", "hello-2.12.1-2.fc39.x86_64.rpm"
  end
end
