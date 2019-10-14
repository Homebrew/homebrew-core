class Shntool < Formula
  desc "Multi-purpose tool for manipulating and analyzing WAV files"
  homepage "https://web.archive.org/web/20180903160820/etree.org/shnutils/shntool/"
  url "https://web.archive.org/web/20180903160820/etree.org/shnutils/shntool/dist/src/shntool-3.0.10.tar.gz"
  mirror "https://www.mirrorservice.org/sites/download.salixos.org/x86_64/extra-14.2/source/audio/shntool/shntool-3.0.10.tar.gz"
  sha256 "74302eac477ca08fb2b42b9f154cc870593aec8beab308676e4373a5e4ca2102"

  bottle do
    cellar :any_skip_relocation
    sha256 "9454d69f59139dd015c7c414fd387016ed192fde5c9772470d3110be98fc8229" => :catalina
    sha256 "3406dd2a363de42f9dab6d2e32e13b16357c6906ad552adb866c272f8dd1f5f2" => :mojave
    sha256 "54203e7c0cf7a257ecc3cec107b55afd14b98edc9b8713082fbf6282eb863e38" => :high_sierra
    sha256 "5548c0401df42faa7ade30e9c98656828864c3677836f72100aa80f4a92ff249" => :sierra
    sha256 "910da256436f55ebf40c487ebd0e74da2979f01bf0adac83272b353c66ba99a8" => :el_capitan
    sha256 "46d99776bb02d9721f30a6cb9b2c44293d3fbc6b4e3f522df869a7106b09a448" => :yosemite
    sha256 "fa745e31b3c2aadb20d5c87f7175f00b3c5a39b6664ea0a9aa9d88d5767781c5" => :mavericks
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
