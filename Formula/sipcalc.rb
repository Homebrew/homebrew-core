class Sipcalc < Formula
  desc "Advanced console-based IP subnet calculator"
  homepage "https://www.routemeister.net/projects/sipcalc/"
  url "https://www.routemeister.net/projects/sipcalc/files/sipcalc-1.1.6.tar.gz"
  sha256 "cfd476c667f7a119e49eb5fe8adcfb9d2339bc2e0d4d01a1d64b7c229be56357"

  livecheck do
    url "https://www.routemeister.net/projects/sipcalc/download.html"
    regex(/href=.*?sipcalc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce581c927477b75b12e92cf656e7de4c93c304be04621a7a4a65a8f8aadeaa02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9eb0d11f79f4a89148dcfba3ff714cad9c345276ce5ca0e8e937782cbc0d0e1d"
    sha256 cellar: :any_skip_relocation, monterey:       "dc22b86797deef059d90b7bd8c07b235556acbad13e6df0575c99ea30359570a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ecd4de1c66d06136e36ec83e076b253212294f0407bf049e1bdf7746505c2ab"
    sha256 cellar: :any_skip_relocation, catalina:       "4b211b4978bd165adb71435e19f19f146ee84f905555c3bce2d4652375067d3d"
    sha256 cellar: :any_skip_relocation, mojave:         "50bc96758ca5ecdb86fb29ca39bf07f6c4e44192310481436afccc191c6f2cd2"
    sha256 cellar: :any_skip_relocation, high_sierra:    "9cff165f5e2b98d0c7d4729d4d6309b679cae7d161996242c666053d37134640"
    sha256 cellar: :any_skip_relocation, sierra:         "1ccdaec0a816dde9f7caa0f7a77cd984ece78a61a5886032c4c8821915753482"
    sha256 cellar: :any_skip_relocation, el_capitan:     "56aa686252ac703ed3dbe91f5737ec4d4b95d52516f4ab52947df15b77d1c58f"
    sha256 cellar: :any_skip_relocation, yosemite:       "6b2fc300755693d382fd5ea971c272a7c8c7bff49614dd88d8db4270aa496012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32b27f7515668c3962b6f3e629928524026bf005b6ed247449779064bb65e1d7"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/sipcalc", "-h"
  end
end
