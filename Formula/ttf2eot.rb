class Ttf2eot < Formula
  desc "Convert TTF files to EOT"
  homepage "https://code.google.com/archive/p/ttf2eot/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/ttf2eot/ttf2eot-0.0.2-2.tar.gz"
  sha256 "023cf04d7c717657e92afe566518bf2a696ab22a2a8eba764340000bebff8db8"

  bottle do
    cellar :any_skip_relocation
    sha256 "85a5617fe0207bf48cb27cac94d9c9b5c2b3ea812a83c71b9d4017b55969302a" => :sierra
    sha256 "e6d90a726548a3321d33135538390ff4bcfda18faf01f97fdea6e3dbd2dee165" => :el_capitan
    sha256 "e0c767aefbe0c95c28c07efdd63a86fb397e0bcb6b42173ff6792ec216aa063f" => :yosemite
    sha256 "8091c9f2a8b3c75c28d4f646ef15e42d6a205e5beeea19d72dc2883623dc5cd6" => :mavericks
  end

  def install
    system "make"
    bin.install "ttf2eot"
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system("#{bin}/ttf2eot < Arial.ttf > Arial.eot")
    assert File.exist?("Arial.eot")
  end
end
