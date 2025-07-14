class Winetricks < Formula
  desc "Automatic workarounds for problems in Wine"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/refs/tags/20250102.tar.gz"
  sha256 "24d339806e3309274ee70743d76ff7b965fef5a534c001916d387c924eebe42e"
  license "LGPL-2.1-or-later"
  head "https://github.com/Winetricks/winetricks.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d{6,8})$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8206662a0e6dc4617ffb4b6c6c3688dd39e019291e95e91eec0e0c2a49b4fcf1"
  end

  depends_on "cabextract"
  depends_on "p7zip"
  depends_on "unzip"

  def install
    bin.install "src/winetricks"
    man1.install "src/winetricks.1"
  end

  test do
    system bin/"winetricks", "--version"
  end
end
