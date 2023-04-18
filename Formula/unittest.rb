class Unittest < Formula
  desc "C++ Unit Test Framework"
  homepage "https://unittest.red-bean.com/"
  url "https://unittest.red-bean.com/tar/unittest-0.50-62.tar.gz"
  sha256 "9586ef0149b6376da9b5f95a992c7ad1546254381808cddad1f03768974b165f"

  livecheck do
    url "https://unittest.red-bean.com/tar/"
    regex(/href=.*?unittest[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c301be0c1a8cabb9339ce5f1a2284c6c9d7c54a3f9458f92563d388ec418f0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc9de7f5271e4a57ce5f2bd565924006f39ebb8f136ba5f4493778007c019ff5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2da59f3f0206902816c2dac6c273768858f092eb917b696b0a8b04096ea97007"
    sha256 cellar: :any_skip_relocation, ventura:        "a6600c783f2a191f11bb0f4b8f236819216ee20e2d4610bcc006a4478a706ded"
    sha256 cellar: :any_skip_relocation, monterey:       "d83feaeec071b449126875572d29d4df64580c06c2f4a8fcc4fca55a5c68c7f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f449bf2ba73aaf03dd8316d6057639bd2c3a38ef347157f3721cbabfb60212f"
    sha256 cellar: :any_skip_relocation, catalina:       "ef8f5c6e18c32b813cb825ce467a6997592dca4762833f8e03f156629ffa74f9"
    sha256 cellar: :any_skip_relocation, mojave:         "a1ab22f2b4904a5c03ea8642fa096166b9fcc131e535a1d15e07772e1fbcea8d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b34ab2aa983e33bf86eda07a58af410a769da7e969620e479c6f7e965de2c397"
    sha256 cellar: :any_skip_relocation, sierra:         "c997c9ce2d6984607af24a6dc7dc21ddefc0570a15d2fb61192b3a361120a83d"
    sha256 cellar: :any_skip_relocation, el_capitan:     "501b61d05de70cfb53116c66daf380cb35a1665eeecf34dfc6b27ab945458f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "253282b6d8bd11e9b124dea0b9356211b422502f0e809cd2f043f791275d7459"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "test/unittesttest"
  end

  test do
    system "#{pkgshare}/unittesttest"
  end
end
