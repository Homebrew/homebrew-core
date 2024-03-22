class Sha3sum < Formula
  desc "Keccak, SHA-3, SHAKE, and RawSHAKE checksum utilities"
  homepage "https://codeberg.org/maandree/sha3sum"
  url "https://codeberg.org/maandree/sha3sum/archive/1.2.3.1.tar.gz"
  sha256 "0271f3b6ac5566b73b18d12ef61e3662b98d25abed7c5da5f0eea12961f260dd"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e4dbe2302deb987ebcd26bddf14d1af291e1d9fbe148d91ad712d46415d0edef"
    sha256 cellar: :any,                 arm64_ventura:  "d3831179596af0f1204aa7705ff943bc7244ea400d7bc1b31d2ecaa1628198c4"
    sha256 cellar: :any,                 arm64_monterey: "f4ec5850831c39ab0e385fcec01c35bce4594f0993ba93a4fa70c3b490ca5cf9"
    sha256 cellar: :any,                 sonoma:         "49e18e7f3e6ec476b8eabb2c938f4e3b7975e552952532238542e8a27631b7e3"
    sha256 cellar: :any,                 ventura:        "9ec92a81602647b0ee6a48f3c1a64d8e33ab8e8365edbab919067f9def58facd"
    sha256 cellar: :any,                 monterey:       "2ea5eadc0bd1ff2ab10c7fc30787082271a9620d1e05993aea05cad7e6c8dd85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddcb3ee8b45d13748d000f36cfe5ead89a45cecf098c7adc43a1a7917f94d75f"
  end

  depends_on "libkeccak"

  def install
    # GNU make builtin rules specify link flags in the wrong order
    # See https://codeberg.org/maandree/sha3sum/issues/2
    system "make", "--no-builtin-rules", "install", "PREFIX=#{prefix}"
    inreplace "test", "./", "#{bin}/"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    system "./test"
  end
end
