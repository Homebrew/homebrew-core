class Snow < Formula
  desc "Whitespace steganography: coded messages using whitespace"
  homepage "https://web.archive.org/web/20200701063014/www.darkside.com.au/snow/"
  # The upstream website seems to be rejecting curl connections.
  # Consistently returns "HTTP/1.1 406 Not Acceptable".
  url "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/snow-20130616.tar.gz"
  sha256 "c0b71aa74ed628d121f81b1cd4ae07c2842c41cfbdf639b50291fc527c213865"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41d88483f63f4e5e20582e409aa08ed0c750e9ab7f7994094927998960eff861"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82e4eb39adb51efc80eb91bcbdee8f4ca6f64efd91c38a6aba5a1e1e3bb71cec"
    sha256 cellar: :any_skip_relocation, monterey:       "a6780f5de96964c392f9abc19a23dd38d73681e0a8d2000429e3d53b5307aef8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cf930203ae4748152f58f0d7a6e8c93eb5d2f6ca1d0498c882da68da599847a"
    sha256 cellar: :any_skip_relocation, catalina:       "9c662e59ae80a814b726baa86faa4e37e85f504e368579ede9e88254af4b8bde"
    sha256 cellar: :any_skip_relocation, mojave:         "bed2d75f7d4210b5bebd533b656bf0ee641f6aaa4665b6c914071d7d1a4a7f04"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7db54bdc60bd0db33bc854e5b95a928183479d1f2d9ec65d69f36d3d8ccdae6a"
    sha256 cellar: :any_skip_relocation, sierra:         "3c975f8c77c450c084b8a468f5d51dd12acaa15dd93dbc440b4523b8dc130316"
    sha256 cellar: :any_skip_relocation, el_capitan:     "5121a5196c5ed20b7496a5190830bf2e49bdd18c3950fc6b1b8fabb239c9ef7c"
    sha256 cellar: :any_skip_relocation, yosemite:       "f4e949f65f946916a5f0b018a75e741336fed9e6434f1802d906e003e9da6b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2e1c6de8181532e1de1703e7ad9cfbb7568faf4c77cb18b2e8eae00fede114a"
  end

  def install
    system "make"
    bin.install "snow"
    man1.install "snow.1"
  end

  test do
    touch "in.txt"
    touch "out.txt"
    system "#{bin}/snow", "-C", "-m", "'Secrets Abound Here'", "-p",
           "'hello world'", "in.txt", "out.txt"
    # The below should get the response 'Secrets Abound Here' when testing.
    system "#{bin}/snow", "-C", "-p", "'hello world'", "out.txt"
  end
end
