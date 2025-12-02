class Treecc < Formula
  desc "Aspect-oriented approach to writing compilers"
  homepage "https://gnu.org/software/dotgnu/treecc/treecc.html"
  url "https://download.savannah.gnu.org/releases/dotgnu-pnet/treecc-0.3.10.tar.gz"
  sha256 "5e9d20a6938e0c6fedfed0cabc7e9e984024e4881b748d076e8c75f1aeb6efe7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/dotgnu-pnet/"
    regex(/href=.*?treecc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f2b78957fb3111f30628833a2f8de46fbb1e2b603fce6edefdee88936759372d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9d079ee6685d1432e363a820725469f633d8d649e235e7bf95a549d8a34b7789"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c98884b6106530ec5a9e7984d5bd9c18637794f9e52168c4877a7f72c0f068a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a9f078361781eeb11f2a5f595c0728c6753af61f8b2876c390d469bde5f1467"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55d7a609393fe94689f48ae77c7e5c579fcfd408fb3c1fc3ea265bbac0dc842f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b29736a869955071e87b8be7b9d8f7a36e1c2d4f52796e49bbef8d5c002147b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4228b4ef75425916287069e7de68723fac704a1ac8ec806d95228497e844124d"
    sha256 cellar: :any_skip_relocation, ventura:        "225da2d6061f4bb879dfc442a62111ec9e181fb3a4730b4b35b9a7c108ae0322"
    sha256 cellar: :any_skip_relocation, monterey:       "e5df47b775de8602bf18db65da4a4eea2093d19fda212ea300c455b4ff899c5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "239d0728cb07d6376c1da25192595b472842acd775b7d95570786fac003ca10f"
    sha256 cellar: :any_skip_relocation, catalina:       "3a46948ef72e0801cab4767e1f0075d01ab8b7a8eb4b07a9a7e81d021c43e2fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0ce0d7869668cc4f7b2f5334f7823cbdfe4685ee548dcfad1132c36a2cca5437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dbfb97ace2365eaa60578f1d0c7ae29b9d30d1a445040df285b9b9ca4fce263"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make"
    bin.install "treecc"
  end

  test do
    system bin/"treecc", "-v"
  end
end
