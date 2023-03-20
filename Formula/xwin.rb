class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.2.11.tar.gz"
  sha256 "3cb5289c609bef487245ed8945accfad4c837b42ba37cd347d5b53ad2523c2d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd21a5cd83bb6decd3c05c00eefecbbc018d403fc825d2b79d4ea0f59fa2dc33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c52ed258dbffb56d3d8d62e31993e2570325d1e35644b3623913efb849655b95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "812069f9f218b39d23df799846fc1e00212ff8112e134ee9df27669a6feae0b6"
    sha256 cellar: :any_skip_relocation, ventura:        "60a033586fcb3c0eea547c588c28bf4ac2c482f2ad4d1b22e722e9d2cf199ff4"
    sha256 cellar: :any_skip_relocation, monterey:       "b4c22d77f48a730696659fce273db9937aa707c1cad5f5ce6b3d281c019400d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c93d53030ec8b78dcdb1c7a779c8ae833f0112e886c90c24acb8fd69d6efa1c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2bed50fdc6fc80f80a48d84b668f5f1c4cbe395f2923fc0b45da08b4eb7f401"
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
