class Tcping < Formula
  desc "TCP connect to the given IP/port combo"
  homepage "https://github.com/mkirchner/tcping"
  url "https://github.com/mkirchner/tcping/archive/refs/tags/2.1.0.tar.gz"
  sha256 "b8aa427420fe00173b5a2c0013d78e52b010350f5438bf5903c1942cba7c39c9"
  license "MIT"
  head "https://github.com/mkirchner/tcping.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f9b6f59dabfa7d65422fa6ec42a7fec5fb60b41aeeeb732b8d90edf146494a47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b43eafbc84776f3718d8fdcad688ca581d2b3e74de5de6f199d6af57ed810930"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3658deb0ed9da1938d4c2a6c4336fdc51ac8a2037365a9b9b19708d5c16d7cd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "126f8832750fd4260255814f399ca26fdd109a8bd52cde1737670b3be389213e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8784cccfd9d750f59c8e9437fde962edc453147d4fdc960f34b047cc4b3eb909"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "291b7eae0dc9f77b2df1d10ed1c685ddf48af0b835b4818f96a256a10b0841c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1cc2aea721c8489ca2f2dd6e6141062bbce6b926e0fbd7137b28d4c33907007"
    sha256 cellar: :any_skip_relocation, ventura:        "74dabc6cf5b77e3251cb11ab8fcd1a6bba24e67fb180871833c11919f193c496"
    sha256 cellar: :any_skip_relocation, monterey:       "90eb918cc445fb97563d157bd1c75ca2abf1a8423c2b83de0d2c101ae13a9c86"
    sha256 cellar: :any_skip_relocation, big_sur:        "0049f186fb30a2217b7a8fe05eacac7e766f666135d5c898221e6cc25455349a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b53bd88f1bb3f5be9aa7c52013cdb0fd60eaf39d8c05baca7556dd8600b4c6f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16c2e18d02839e6b0e79ac685045de38f37afd44543cd43c82ae1e0cec435282"
  end

  def install
    system "make"
    bin.install "tcping"
  end

  test do
    system bin/"tcping", "www.google.com", "80"
  end
end
