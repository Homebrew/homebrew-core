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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "dac7c49e9256da92adfb0d881f723ad8869043632b6e81b03b0dfb1efa184822"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c5d116fc457d0cb26ccaea1e50b59a4edae2af2e89064c473aa420717dc0a9c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9147bd0667159d62ea4493ae1524f8779f4fb19eb34ac4fc109695e09cdcd7ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec3c0feb069099563b7359c7e3f926ac1840aaf0364bf40be1a2cf1462865764"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02dd5226afa9d564374ab0e56a1edd08d7b61ac8c9c7fb09ec2dc011d47cb955"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dfa65178720559cebc5500eb9f32d4ca2606a4f1b6a94b9d175ceded8fae2f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "15ecde34bad9a23f28114d8703059e33e330244f56150997bda24abf77a9a13f"
    sha256 cellar: :any_skip_relocation, ventura:        "f8a5ea952382da86b8ebc29ccc1ab8c4d818a69a408c7e2adbd9cec2139fb5e6"
    sha256 cellar: :any_skip_relocation, monterey:       "858a65a08549e69ecc02979700c5155426f0a8202da7e6ec48bc0018a6ed9038"
    sha256 cellar: :any_skip_relocation, big_sur:        "c265916725e367c0b187924177b6e5d9ed12d434f242e6bc7b59596a02f08c71"
    sha256 cellar: :any_skip_relocation, catalina:       "e140337ce89f886c0044ac6eaf75dda3711622f9da418932e8a02337213785ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c719e4057a5cd6801dc734c26f3643e241bd0b547e91663a993ae62bbcb65de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca983c20f607f60e0bd5f2ea6bc5d138606351fada22c01b315d388e8620c3c1"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"shninfo", test_fixtures("test.wav")
  end
end
