class Shntool < Formula
  desc "Multi-purpose tool for manipulating and analyzing WAV files"
  homepage "http://shnutils.freeshell.org/shntool/"
  url "http://shnutils.freeshell.org/shntool/dist/src/shntool-3.0.10.tar.gz"
  mirror "https://www.mirrorservice.org/sites/download.salixos.org/x86_64/extra-14.2/source/audio/shntool/shntool-3.0.10.tar.gz"
  sha256 "74302eac477ca08fb2b42b9f154cc870593aec8beab308676e4373a5e4ca2102"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://shnutils.freeshell.org/shntool/dist/src/"
    regex(/href=.*?shntool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02dd5226afa9d564374ab0e56a1edd08d7b61ac8c9c7fb09ec2dc011d47cb955"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dfa65178720559cebc5500eb9f32d4ca2606a4f1b6a94b9d175ceded8fae2f0"
    sha256 cellar: :any_skip_relocation, monterey:       "858a65a08549e69ecc02979700c5155426f0a8202da7e6ec48bc0018a6ed9038"
    sha256 cellar: :any_skip_relocation, big_sur:        "c265916725e367c0b187924177b6e5d9ed12d434f242e6bc7b59596a02f08c71"
    sha256 cellar: :any_skip_relocation, catalina:       "e140337ce89f886c0044ac6eaf75dda3711622f9da418932e8a02337213785ca"
    sha256 cellar: :any_skip_relocation, mojave:         "8f318573fa965da7dc5fcff667f2f9ee3295e2034a6c877a9d182459f08308f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca983c20f607f60e0bd5f2ea6bc5d138606351fada22c01b315d388e8620c3c1"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shninfo", test_fixtures("test.wav")
  end
end
