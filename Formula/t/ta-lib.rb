class TaLib < Formula
  desc "Tools for market analysis"
  homepage "https://ta-lib.org/"
  url "https://github.com/ta-lib/ta-lib/releases/download/v0.7.1/ta-lib-0.7.1-src.tar.gz"
  sha256 "508981a5b85edab42ecee0b2d9c7dcd2c4ae9831e859e1aa4e549232734c27e1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "615037c0200f975c14d6f0001028f3426acd8cc0a045c00291a255fc7095da17"
    sha256 cellar: :any, arm64_sequoia: "0534ee3f9f69847a53671a4812a33e8772f5b5a930cb1c6f5a5dde68623669a0"
    sha256 cellar: :any, arm64_sonoma:  "4cdab731fd05fab25a8f36aa22e9ec4379bf84aa12d9aad5f594389f288d899d"
    sha256 cellar: :any, sonoma:        "0e3ab108a472af579c786be012b0863d9e60e84bb325f7ca68fe728d7061450b"
    sha256 cellar: :any, arm64_linux:   "e05ea2875d1deb8277e32304fc89e628e46bdbe8835707cc839de89ecca8f8eb"
    sha256 cellar: :any, x86_64_linux:  "0eebdb7a3a2692591b9ffe32e85fb9ac2f9a8db194277b8c16a784420612df8a"
  end

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    ENV.deparallelize
    # Call autoreconf on macOS to fix -flat_namespace usage
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?
    system "./configure", *std_configure_args
    system "make", "install"
    bin.install "src/tools/ta_regtest/.libs/ta_regtest"
  end

  test do
    system bin/"ta_regtest"
  end
end
