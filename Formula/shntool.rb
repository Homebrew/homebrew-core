class Shntool < Formula
  desc "Multi-purpose tool for manipulating and analyzing WAV files"
  homepage "http://shnutils.freeshell.org/shntool/"
  url "http://shnutils.freeshell.org/shntool/dist/src/shntool-3.0.10.tar.gz"
  mirror "https://www.mirrorservice.org/sites/download.salixos.org/x86_64/extra-14.2/source/audio/shntool/shntool-3.0.10.tar.gz"
  sha256 "74302eac477ca08fb2b42b9f154cc870593aec8beab308676e4373a5e4ca2102"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "c265916725e367c0b187924177b6e5d9ed12d434f242e6bc7b59596a02f08c71" => :big_sur
    sha256 "1dfa65178720559cebc5500eb9f32d4ca2606a4f1b6a94b9d175ceded8fae2f0" => :arm64_big_sur
    sha256 "e140337ce89f886c0044ac6eaf75dda3711622f9da418932e8a02337213785ca" => :catalina
    sha256 "8f318573fa965da7dc5fcff667f2f9ee3295e2034a6c877a9d182459f08308f8" => :mojave
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shninfo", test_fixtures("test.wav")
  end
end
