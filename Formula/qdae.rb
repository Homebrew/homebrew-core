class Qdae < Formula
  desc "Quick and Dirty Apricot Emulator"
  homepage "http://www.seasip.info/Unix/QDAE/"
  url "http://www.seasip.info/Unix/QDAE/qdae-0.0.10.tar.gz"
  sha256 "780752c37c9ec68dd0cd08bd6fe288a1028277e10f74ef405ca200770edb5227"

  bottle do
    sha256 "8f8bacc65658df8d20648da83bfb6cb73738ce2f50c4c8dd96b3d59ee2238046" => :el_capitan
    sha256 "7c6215e807e24d1a22e9186329c17fb7cdcf19cba797483e6340aecfe42e3c36" => :yosemite
    sha256 "a0c2bc5437cdb373ec43932e98237daa3a33b330afa0c68122c9de6afd94836d" => :mavericks
  end

  depends_on "sdl"
  depends_on "libxml2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Data files are located in the following directory:
      #{share}/QDAE
    EOS
  end

  test do
    File.executable? "#{bin}/qdae"
  end
end
