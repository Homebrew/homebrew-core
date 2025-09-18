class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.6.7.tar.gz"
  sha256 "daab92c9c25acc54c8ccbbad22aed8fa0726fa0935dde0aa01a6a9ce10d439ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d4489a121e4d82ff0e69d85d3f5c137a5b28777bbb1cdb15a384190a1b3addc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0573062f217fcccb1f570e78b3b135d5209a42b35d54395ddbd21c09c0194daf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ed3b641edaebcc7db4efd1510da83f3bce8e53b57a7114994546c4eb6866dc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb2016cef3c7caedb4dbf1f5cd80206fb3d088288f5ad4d2c4e6b521862499fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6d5b7d5ddd85d0b0ef3e3639a88d87dca35db99af32d85c3cfd2dc3901b6a19"
    sha256 cellar: :any_skip_relocation, ventura:       "09332a83b86db6f25994813fe0335339963ceb332a9af00fea03171d158a415c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5af872f7083155a3aacde6d1abb1bb5e0a7e2dccc618fa7efd1105e3b9fff5b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "043043fed05eafbad11e99902f4f766a36b9469a9c2a5af791f0701132e482fd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_path_exists testpath/".xwin-cache/splat"
  end
end
