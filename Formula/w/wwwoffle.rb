class Wwwoffle < Formula
  desc "Better browsing for computers with intermittent connections"
  homepage "https://www.gedanken.org.uk/software/wwwoffle/"
  url "https://www.gedanken.org.uk/software/wwwoffle/download/wwwoffle-2.9j.tgz"
  sha256 "b16dd2549dd47834805343025638c06a0d67f8ea7022101c0ce2b6847ba011c6"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.gedanken.org.uk/software/wwwoffle/download/"
    regex(/href=.*?wwwoffle[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a7047aea7ece9dfdee1b2f1ed3c8fe41c90a51c6411e523b63105e49d80857ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "114a59c443772a746833b3431d2cd275755ae5f8eed92326c7763e2097eca980"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dba1da001f686548a7ba1ecb2bb6a2fe34a5fb6c821846c3f47c3d6bf461ca1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f20e830e259aeb9fabef5702a220934f688385a47a91d90dd8fffdb09f79f1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb1c21a7a1850d20ea78fbf76ee08b7b2341b3f37c23ea0f1a298416b18b613c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "539834a9911070c87d6c34d0b12a16ab29d58fa4688f74ca1103c90c58364db1"
    sha256 cellar: :any_skip_relocation, sonoma:         "80adf385afba9d02106863608c488a5d0e385fb1b444dea3d5416a59b51e9283"
    sha256 cellar: :any_skip_relocation, ventura:        "69e42ae01329c558154b980a98a590d65c70adb3ab97732c02ced755c24bce06"
    sha256 cellar: :any_skip_relocation, monterey:       "c9d09ae17f69d7f18e421b2ab893a1dccd64d15ad9a41f0d987c1c9c81bfaf86"
    sha256 cellar: :any_skip_relocation, big_sur:        "46fe1104b067d2e6c93edf3f4d3ca12e82e2e6b3db5ba99b3b94d3d4ce23fc6a"
    sha256 cellar: :any_skip_relocation, catalina:       "5e01196bd5b95300b944ac6c5bd7cf10999a3ec9cb24f2f2a09b97b0256b87f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "364d7e80791686aea7174f34a719f858612c73c1e9e7d99dccb6a70b13a7f6e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddd784479bb56270b0d643cb2cccbc9e48264423c4190c1a1b251988dd503b68"
  end

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"wwwoffle", "--version"
  end
end
