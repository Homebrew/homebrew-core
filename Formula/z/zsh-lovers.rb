class ZshLovers < Formula
  desc "Tips, tricks, and examples for zsh"
  homepage "https://grml.org/zsh/#zshlovers"
  url "https://deb.grml.org/pool/main/z/zsh-lovers/zsh-lovers_0.10.0_all.deb"
  sha256 "8c65f410fcb2c6fc20bd5a0b509a0f4c88b6380652ecaf15bdd12999ef92e791"

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
