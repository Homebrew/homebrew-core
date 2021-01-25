class Smimesign < Formula
  desc "S/MIME signing utility for use with Git"
  homepage "https://github.com/github/smimesign"
  url "https://github.com/github/smimesign/archive/v0.1.0.tar.gz"
  sha256 "b01443a54354c0ceab2501403b67b76e3cf2b12dcd9f0474e18a22c66099e589"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa8df0fdb6acb090de4eacca0b1b83825b6fa594c7743981be42654fede1b797" => :big_sur
    sha256 "1ff41bca0d768e6939c790b7f0cb01a22e15710f4a286b0aba1de3940e4f7d6a" => :arm64_big_sur
    sha256 "abad2ebcdf7f1c0eb58badee31d787e9a986b99ea17e79013acfeb437a4537e9" => :catalina
    sha256 "56af904bbe4aa96d755ef99b67145ee20c57d0a0fc1681fe9c6333e19ce68be3" => :mojave
    sha256 "024a4963b723bd2ec94fde2a578cb80342f4837d9ec34158ae023479c4157f33" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.versionString=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smimesign --version")
    system "#{bin}/smimesign", "--list-keys"
    assert_match "could not find identity matching specified user-id: bad@identity",
      shell_output("#{bin}/smimesign -su bad@identity 2>&1", 1)
  end
end
