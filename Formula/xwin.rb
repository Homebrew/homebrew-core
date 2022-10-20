class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.2.9.tar.gz"
  sha256 "e53bf34952623f6a306e3ee1a73ac63108e349b76a7e25054230baefdb9f7606"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cbfb83c38f6139d2c4173d835b520bbfd8c24d4c69e76110794b213cea14638"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c46d9cb7e3ead0fe8fa3c250d00257b237c87d40c3a09850701c4795f2f407d5"
    sha256 cellar: :any_skip_relocation, monterey:       "371494737b247a91c4a52bea788230d44a19c4a719634fe3ba3b90ba235a4a5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a33871a02743c442f8d67ff7a17c14255527c9f904f3f70b63fcb375e88552c6"
    sha256 cellar: :any_skip_relocation, catalina:       "3123bc95fd1671a618594b0ce6b711e95ce1a95ed74753592bf03fbcd6bddad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "673cb461d7f6f3018071f4d107acc593454288dcf4ab2486a9e5b13d6eb87923"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_predicate testpath/".xwin-cache/splat", :exist?
  end
end
