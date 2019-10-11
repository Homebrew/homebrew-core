class Xdotool < Formula
  desc "Fake keyboard/mouse input and window management for X"
  homepage "https://www.semicomplete.com/projects/xdotool/"
  url "https://github.com/jordansissel/xdotool/archive/v3.20160805.1.tar.gz"
  sha256 "ddafca1239075c203769c17a5a184587731e56fbe0438c09d08f8af1704e117a"

  bottle do
    sha256 "bd900636739173b1da41c392f04145905263c458844cd248f2bf00f3ccdc0d2b" => :catalina
    sha256 "02edb6e55146177191ec888e7886878b2bf93defb20a2e6a01546bce111859b8" => :mojave
    sha256 "2f949fc70d828db23364beed16bdbd15c728d790601e5e0a59b110f8f6eb3826" => :high_sierra
    sha256 "13b1b017e94c76bde510b06427cf517c0d78028994e3b1bb8501ec2cbd5c7ef1" => :sierra
    sha256 "d7fad4610977a3a5f8879b4f51d35e08e4ef3e65cfbc04353e67bdc14b279867" => :el_capitan
    sha256 "037a599194a39189e8d8397c358dce21c1425065fdeeb29e59db26b696425f63" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libxkbcommon"

  depends_on :x11

  def install
    # Work around an issue with Xcode 8 on El Capitan, which
    # errors out with `typedef redefinition with different types`
    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      ENV.delete("SDKROOT")
    end

    system "make", "PREFIX=#{prefix}", "INSTALLMAN=#{man}", "install"
  end

  def caveats; <<~EOS
    You will probably want to enable XTEST in your X11 server now by running:
      defaults write org.x.X11 enable_test_extensions -boolean true

    For the source of this useful hint:
      https://stackoverflow.com/questions/1264210/does-mac-x11-have-the-xtest-extension
  EOS
  end

  test do
    system "#{bin}/xdotool", "--version"
  end
end
