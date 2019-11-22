class Rav1e < Formula
  desc "The fastest and safest AV1 encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/0.1.0.tar.gz"
  sha256 "00395087eaba4778d17878924e007716e2f399116b8011bf057fd54cc528a6cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "1367e1ee122f6c24213d78e7ec5c26545ebc5a901ffb5b129013282e06175bc8" => :catalina
    sha256 "f2e114c452d5abca2e1ec3635add73036520092f25db8285a5d35b7125483098" => :mojave
    sha256 "d7677873a6ddb3c9818aadc04324727bd7d402ec930609dbbffff47cb931337a" => :high_sierra
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  resource "bus_qcif_15fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  def install
    system "cargo", "install", "--locked",
                               "--root", prefix,
                               "--path", "."
  end

  test do
    resource("bus_qcif_15fps.y4m").stage do
      system "#{bin}/rav1e", "--tile-rows=2",
                                   "bus_qcif_15fps.y4m",
                                   "--output=bus_qcif_15fps.ivf"
    end
  end
end
