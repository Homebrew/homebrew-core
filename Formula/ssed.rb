class Ssed < Formula
  desc "Super sed stream editor"
  homepage "https://sed.sourceforge.io/grabbag/ssed/"
  url "https://sed.sourceforge.io/grabbag/ssed/sed-3.62.tar.gz"
  sha256 "af7ff67e052efabf3fd07d967161c39db0480adc7c01f5100a1996fec60b8ec4"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "8ead33fc5954cd35bdff6291cec76e4ee2d6011d0f4d7025e832c9fa2514c31b" => :big_sur
    sha256 "2b6c860af3e99b067b867a53b1b7135918cf1ff10e27b744a4157c2134b866f5" => :arm64_big_sur
    sha256 "69a3bbba8a87299f96f1b51c612d3335d1114ffb0bc6aa186c6f3e87335767e6" => :catalina
    sha256 "b3b9297ad7ac202de1403508682aaf1dbb187fe3ab1f4c6cc9bee7b7a69ab1d9" => :mojave
  end

  conflicts_with "gnu-sed", because: "both install share/info/sed.info"

  def install
    # CFLAGS adjustment is needed to build on Xcode 12
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--program-prefix=s"
    system "make", "install"
  end

  test do
    assert_equal "homebrew",
      pipe_output("#{bin}/ssed s/neyd/mebr/", "honeydew", 0).chomp
  end
end
