class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.6.5.tar.gz"
  sha256 "01fbb8c9b11d71388f0836cd112caf32a0b5c29e7307396594ec8391a815c19c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4037b8f7f0cc14cc0ceeef6bbcda2a8bc884eaf644c8a7fe28c5954a1bf1c526"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "024ef02449c4a8def7975e5a888029ad67057092f46bc3a834c986dc267d7d3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88a0344d220aa9b7efdf4eac804dc4f4d045a862658e73e5d4206006821acb8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b991244b55050f4b79a5e42245863ebdc624f8b42138ddd6741713a8f40d8e76"
    sha256 cellar: :any_skip_relocation, sonoma:         "8eb6be6eddc5bdaa98e9bedd06e15fe9dd98189ff5ee9f969093160eb91d0b3b"
    sha256 cellar: :any_skip_relocation, ventura:        "3b9c9cc7645f66e685ad98c7f9a450b45bfc36eddbcea151f25c857f132c28b9"
    sha256 cellar: :any_skip_relocation, monterey:       "ecee39a502597e5ce214487c8031c1b2679a835390b3385fbe0fafe7592d2ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "244e179fcfcca8f1df7ca7d9490764602279f6dc45a678b5dfb2845ef5cb95ff"
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
