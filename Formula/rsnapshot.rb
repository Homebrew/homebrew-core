class Rsnapshot < Formula
  desc "File system snapshot utility (based on rsync)"
  homepage "https://www.rsnapshot.org/"
  url "https://github.com/rsnapshot/rsnapshot/releases/download/1.4.2/rsnapshot-1.4.2.tar.gz"
  sha256 "042a81c45b325296b21c363f417985d857f083f87c5c27f5a64677a052f24e16"
  head "https://github.com/DrHyde/rsnapshot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "58aaff911593d284a63426d0ec4f1328910b9a6cb5a6ecb64f4853d0300a3184" => :mojave
    sha256 "27e99660b73118874b5ba4ba355a0bf9b5db71933138a6b719869da01164a12a" => :high_sierra
    sha256 "998faa778dcfdef5b362b10aeaffadc97e40f63ec6df72d9bd25029ab82f2550" => :sierra
    sha256 "21823489c045150e8d8e51addba52b6cd75eedaec93357732db859ba738f59d5" => :el_capitan
    sha256 "d6374fba65d24f7067197c9a7732f6f629dcb537f0687ab91f4f15d5c55d6cc6" => :yosemite
    sha256 "66cc127c640855b029881b2cd029197b093d92b8d77c3bb9a61167cbaedfedd8" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/rsnapshot", "--version"
  end
end
