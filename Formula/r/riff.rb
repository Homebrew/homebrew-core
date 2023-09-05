class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/2.25.2.tar.gz"
  sha256 "ea108289c0516ecabd35974208d360b189be1ad07f3d67883ff8784c8776b21c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f9c38c293ab83aebdbd604ba04c8bc9a172318cb91d600b0cf4f1fc001d1605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f48a8c0e0a426bdbb472c97de61205e8522d2d03652eed3cfa0a484db98b015"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "119bcf55cc26b00dd64fa7be318e937f21e7670de9c27f7fa8eb04bb4849d649"
    sha256 cellar: :any_skip_relocation, ventura:        "978b0f321d38d0ac876c8b49e00be58731915547d820651a88c91a79e801ee16"
    sha256 cellar: :any_skip_relocation, monterey:       "f885f9850eaa501e02232f0e09ce50a48f588c370b5ef799e698f09da74b5a56"
    sha256 cellar: :any_skip_relocation, big_sur:        "026b6af3ee084d1104964e40c504c80e4d8d47bdcb8cab80aeba149222e5d20e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a038e9df51fea41a2fe70823ed3887bab88f69a38d4203f76885bdc2f0fd4293"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
