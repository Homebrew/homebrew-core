class Stuntman < Formula
  desc "Implementation of the STUN protocol"
  homepage "https://www.stunprotocol.org"
  url "https://www.stunprotocol.org/stunserver-1.2.16.tgz"
  sha256 "4479e1ae070651dfc4836a998267c7ac2fba4f011abcfdca3b8ccd7736d4fd26"
  license "Apache-2.0"
  head "https://github.com/jselbie/stunserver.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?stunserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9ff0ae91033b2b01cc9f72180bc752ef48318ec70f538caf943f0baf1fd3bff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54d82da2aa9283edd6641bd761cd1c45411d4305ae648672ae3e98079d841894"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c875f14ba13aacc89c0f798cbbea161aac655bf3bcaf9284645eb43aea764b55"
    sha256 cellar: :any_skip_relocation, ventura:        "74ddc9697def76e912a283a68da40099a7fd5195960707981d3d8b3c393b2882"
    sha256 cellar: :any_skip_relocation, monterey:       "9ad956118fe74ee3af2a673b6a1afc0736d39f51342cb7f4b926dc13e0d28cab"
    sha256 cellar: :any_skip_relocation, big_sur:        "3180e4e3c719363753cefef52e45972031815f2709760c6b63b4d4e9721e1d4a"
    sha256 cellar: :any_skip_relocation, catalina:       "2ac7951871edd61c9b254d5436a1b8ba1d939908a9a22ac3ef05b975d34490a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bddee00f936559705e2837cc56956efbc2569f98da27d7abb41640d7f87df7d0"
  end

  depends_on "boost" => :build

  # on macOS, stuntman uses CommonCrypt
  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "make"
    bin.install "stunserver", "stunclient", "stuntestcode"
  end

  test do
    system "#{bin}/stuntestcode"
  end
end
