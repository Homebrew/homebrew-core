class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.3.1.tar.gz"
  sha256 "a3731ac69543105b48ccbfe5b361938a889494dec6b5ecbf127fce84e713e098"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b3b86ab0aea1a5c7aca46fff57d4ea9709b9b935d1772beaeda34d6aff4444e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83523838f7a32e07380169059ff3558ef253f599bb671f722a45bafbec93be39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e77c84f37642a9f1ea4a3b70e076a8b1c64df84ad34c2211265080c5fcbe272"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ad900f936e6af437e18431ebb3318be52f474729cafe9cd92c05438825dbcb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd555452c47e118bc554d2d5b8d5bd6f618dfc6f3b607c0b039e5f2552747627"
    sha256 cellar: :any_skip_relocation, ventura:        "85085edc4baa4e1b9b0ea3491838d86548c82fb922dee32677af332c5a99ccde"
    sha256 cellar: :any_skip_relocation, monterey:       "b559b6e3996505f28ad7934ad284d553f7446e4dddbdb115c3df74a70a7dcf19"
    sha256 cellar: :any_skip_relocation, big_sur:        "3acaca1ceeeaf14d8c16b91d8571bc1142773da5709bf4cfc85adccf35704608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f204ff5340ee029d3ef6ea6a66f861c26a5d8a82018ab5ca264dc4c0341f7b6"
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
