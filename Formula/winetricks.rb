class Winetricks < Formula
  desc "Automatic workarounds for problems in Wine"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/20220411.tar.gz"
  sha256 "c16e09ee4e5fda48a49ae9515a9c6d175713792be1b85ea92624d93e37effbd0"
  license "LGPL-2.1-or-later"
  head "https://github.com/Winetricks/winetricks.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d{6,8})$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f33dcdbdaa19fb315454a79234f5b1edf2f3ddc8489c0f0c57670bd10fc2c990"
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
