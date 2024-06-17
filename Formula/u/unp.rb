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
    sha256 cellar: :any_skip_relocation, all: "cff4524f4309c7215312f1a4408493e220c807c4040ef6a1c9bf3da00036a061"
  end

  depends_on "p7zip"

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
    system "#{bin}/unp", "test.gz"
    assert_equal "Homebrew", path.read
  end
end
