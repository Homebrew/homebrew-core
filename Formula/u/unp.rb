class Unp < Formula
  desc "Unpack everything with one command"
  homepage "https://tracker.debian.org/pkg/unp"
  url "https://deb.debian.org/debian/pool/main/u/unp/unp_2.0.tar.xz"
  sha256 "651764eeed41331e699ead891334e3d9512048f6891d55db7761412323622970"
  license "GPL-2.0-only"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/u/unp/"
    regex(/href=.*?unp[._-]v?(\d+(?:\.\d+)+(?:~pre\d+)?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "fdcd81250f756b4075c45a1a4ca5282fab58f2b70008d85da4ad3fdd6b91738b"
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
    system bin/"unp", "test.gz"
    assert_equal "Homebrew", path.read
  end
end
