class Unp < Formula
  desc "Unpack everything with one command"
  homepage "https://packages.debian.org/source/stable/unp"
  url "https://deb.debian.org/debian/pool/main/u/unp/unp_2.0~pre10.tar.xz"
  version "2.0-pre10"
  sha256 "e3d7a87bdc6dc0e86ab522cc93ce368d10a0bdb12959c91a01d3b4f0e3c56800"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?unp[._-]v?(\d+(?:\.\d+)+(?:~pre\d+)?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9d9e14ab7a49de2c7b75129cfde894bba09ab91ac9aa36b2fcf3214928ab0889"
  end

  depends_on "p7zip"

  conflicts_with "uutils-coreutils", because: "both install `ucat` binaries"

  def install
    bin.install %w[unp ucat]
    man1.install "debian/unp.1"
    bash_completion.install "debian/unp.bash-completion" => "unp"
    %w[COPYING CHANGELOG].each { |f| rm f }
    mv "debian/README.Debian", "README"
    mv "debian/copyright", "COPYING"
    mv "debian/changelog", "ChangeLog"
  end

  test do
    path = testpath/"test"
    path.write "Homebrew"
    system "gzip", "test"
    system bin/"unp", "test.gz"
    assert_equal "Homebrew", path.read
  end
end
