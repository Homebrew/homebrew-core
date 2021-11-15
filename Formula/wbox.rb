class Wbox < Formula
  desc "HTTP testing tool and configuration-less HTTP server"
  homepage "http://hping.org/wbox/"
  url "http://www.hping.org/wbox/wbox-5.tar.gz"
  sha256 "1589d85e83c8ee78383a491d89e768ab9aab9f433c5f5e035cfb5eed17efaa19"

  livecheck do
    url :homepage
    regex(/href=.*?wbox[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1827a6a134cf36e397ab072de38c15f9b8689a50c6018b17adce1ad9a7f50fa3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e87df4ac144cb716bd7528c15170376927aebc7f50d72dcd704ff4a5d3b45246"
    sha256 cellar: :any_skip_relocation, monterey:       "b6f52742ac3a5c84240edc1d4e6517a8fe9b03415df69060efe43a35549dda06"
    sha256 cellar: :any_skip_relocation, big_sur:        "21c7d9bd3cdbc504149109c8f9c1b3245ce31cc1a34536e326703b4e108e4c8b"
    sha256 cellar: :any_skip_relocation, catalina:       "512db23fe4356c552e240cf3457ff50225bb6d01fd786df356fb39e4b8f18288"
    sha256 cellar: :any_skip_relocation, mojave:         "bce72c30f26da03ab104082abaccd775fa721b4db98a0ae6e16e2946f59a8bed"
    sha256 cellar: :any_skip_relocation, high_sierra:    "6e8b41d8caf8ae84cf5ff0d7fe9bdb7d83b9c7afae9a746fe319e67fe145cf2c"
    sha256 cellar: :any_skip_relocation, sierra:         "241edb51af197d72022a48cb8444506188269b335b057ceaa7bf952db86777d8"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0e813a0982d6b9228217f14352812d9e6880cce44757f8af9a0447bf5e4a1e63"
    sha256 cellar: :any_skip_relocation, yosemite:       "ee2bd7599a73c3a9f3fe9f8c2d441d753914981b2420e591050780d436bbf011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7b840389d15d72983d68617019bc052ddcea1249468c939f53c70dc3d1dede3"
  end

  def install
    system "make"
    bin.install "wbox"
  end

  test do
    system "#{bin}/wbox", "www.google.com", "1"
  end
end
