class Stress < Formula
  desc "Tool to impose load on and stress test a computer system"
  homepage "https://github.com/resurrecting-open-source-projects/stress"
  url "https://github.com/resurrecting-open-source-projects/stress/archive/refs/tags/1.0.7.tar.gz"
  sha256 "cdaa56671506133e2ed8e1e318d793c2a21c4a00adc53f31ffdef1ece8ace0b1"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "bc133ce107c928388f3e8e1ae2ec46c12fac73f1ae01281486530180d60adba7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7b3708a81bbe9930b49170bb1bbed935a7f4ef6e1c0aa5d6501ab2fa4d2598a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70295f81088618111fc3a3c27d91de5518f63f275b161f3552b52aa8237eb433"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f744647b8c4d3d83ecedd29b802bcf4d03b8fde7ca5a659caceb3d3bf4a19df8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecf4d28b29d30fe0d43c30d5bb8f5bb119842694a04dcefdbef78a37ce0adb77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8ec9b4a8cd6c22f4987344d6db9d9287a54b0e9ec45897dae46deb1c49684da"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c8460f9a1805d20e6f36f2e4768dce9ba5ade639186fa9204439fe52a55e2c3"
    sha256 cellar: :any_skip_relocation, ventura:        "7c8d2136d92522af1285918a98ee6f175252ce4a575997aa34f05de62cab378a"
    sha256 cellar: :any_skip_relocation, monterey:       "35747dadcf335894c442ffccfc3e85f16f35f404aae3e7630015abaeea2f6890"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c0e687b08b14497b89ff3fee89e878808c32dd73d3ea1452ec5bfd49abab88c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f11fdfe50b66032ffa18ef2b2f7a4439b379f08b6224c5c0ee9acde23ae1e6c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffa76db1094886481f76dcba90c949bd03f5d29971e943d9dce96a5f53f6da78"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"stress", "--cpu", "2", "--io", "1", "--vm", "1", "--vm-bytes", "128M", "--timeout", "1s", "--verbose"
  end
end
