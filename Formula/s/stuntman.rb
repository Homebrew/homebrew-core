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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "edaf5c91bca97b2753c2c91faf0c174e2310e48c98ede3b6aa28f5d679ff4369"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0fb5a56446295b44863623d302e1d87d56304f6e48d8afa3b465fd6cb191c891"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f074ff4dfa646a4ddd4bca3606f9e0b69667e79670fbc119b3c538db13fe58a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9ff0ae91033b2b01cc9f72180bc752ef48318ec70f538caf943f0baf1fd3bff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54d82da2aa9283edd6641bd761cd1c45411d4305ae648672ae3e98079d841894"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c875f14ba13aacc89c0f798cbbea161aac655bf3bcaf9284645eb43aea764b55"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7ebbf887c71acd20349ad10d69f4f0e4fd5106bdc2c42bc1d804b84dea42782"
    sha256 cellar: :any_skip_relocation, ventura:        "74ddc9697def76e912a283a68da40099a7fd5195960707981d3d8b3c393b2882"
    sha256 cellar: :any_skip_relocation, monterey:       "9ad956118fe74ee3af2a673b6a1afc0736d39f51342cb7f4b926dc13e0d28cab"
    sha256 cellar: :any_skip_relocation, big_sur:        "3180e4e3c719363753cefef52e45972031815f2709760c6b63b4d4e9721e1d4a"
    sha256 cellar: :any_skip_relocation, catalina:       "2ac7951871edd61c9b254d5436a1b8ba1d939908a9a22ac3ef05b975d34490a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cf40ac5709a4a0db7eee925acc32d0b2ca7e3a8b4dc3548314d3f2377060e1ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bddee00f936559705e2837cc56956efbc2569f98da27d7abb41640d7f87df7d0"
  end

  depends_on "boost" => :build

  # on macOS, stuntman uses CommonCrypt
  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV.cxx11

    system "make"
    bin.install "stunserver", "stunclient", "stuntestcode"
  end

  test do
    system bin/"stuntestcode"
  end
end
