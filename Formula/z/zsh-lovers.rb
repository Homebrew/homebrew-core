class ZshLovers < Formula
  desc "Tips, tricks, and examples for zsh"
  homepage "https://grml.org/zsh/#zshlovers"
  url "https://deb.grml.org/pool/main/z/zsh-lovers/zsh-lovers_0.9.1_all.deb"
  sha256 "011b7931a555c77e98aa9cdd16b3c4670c0e0e3b5355e5fd60188885a6678de8"

  livecheck do
    url "https://deb.grml.org/pool/main/z/zsh-lovers/"
    regex(/href=.*?zsh-lovers[._-]v?(\d+(?:\.\d+)+)[._-]all/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a9a640ed5452e086874d853453e15cbd2e347a5a86d867db12a5245980f6aa54"
  end

  def install
    system "tar", "xf", "zsh-lovers_#{version}_all.deb"
    system "tar", "xf", "data.tar.xz"
    system "gunzip", *Dir["usr/**/*.gz"]
    prefix.install_metafiles "usr/share/doc/zsh-lovers"
    prefix.install "usr/share"
  end

  test do
    system "man", "zsh-lovers"
  end
end
