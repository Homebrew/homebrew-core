class Winetricks < Formula
  desc "Automatic workarounds for problems in Wine"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/20210206.tar.gz"
  sha256 "705421798b28696f577104ebdf03b068b9343ab096754150f47a6ec06fa8ae65"
  license "LGPL-2.1-or-later"
  head "https://github.com/Winetricks/winetricks.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a0d789f5afc57d083be7483626af1f80ac2a56055288d9c7dab572a9f1ae929"
  end

  depends_on "cabextract"
  depends_on "p7zip"
  depends_on "unzip"

  def install
    bin.install "src/winetricks"
    man1.install "src/winetricks.1"
  end

  test do
    system "#{bin}/winetricks", "--version"
  end
end
