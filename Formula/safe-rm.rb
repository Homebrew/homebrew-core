class SafeRm < Formula
  desc "Wraps rm to prevent dangerous deletion of files"
  homepage "https://launchpad.net/safe-rm"
  url "https://launchpad.net/safe-rm/trunk/1.1.0/+download/safe-rm-1.1.0.tar.gz"
  sha256 "a1c916894c5b70e02a6ec6c33abbb2c3b3827464cffd4baffd47ffb69a56a1e0"
  license "GPL-3.0-or-later"
  head "https://git.launchpad.net/safe-rm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c20fa231e0866acc6808e17a8c570d77c9f288f538c0aabeceeb1e69c835031a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "843d018422bc9b5463f5c28c733ced5cd3a1c6c245de4c92f91da5f3b8bc458b"
    sha256 cellar: :any_skip_relocation, monterey:       "8d8fb0fed3fa66429e11301eb243de6c3b240c06192dd87b36688d53ecd5d66e"
    sha256 cellar: :any_skip_relocation, big_sur:        "702abe3719e6da0cc02c5b43c1a9e3878e8dd2dd30b2e214634545afe380f061"
    sha256 cellar: :any_skip_relocation, catalina:       "206ed06e860f2474decb800b55326bf0fc0c82cd848b8a414ba7181cb56028d5"
    sha256 cellar: :any_skip_relocation, mojave:         "fadf91df17e3698589e9c38cb281ce3ee9d7ce34ce53695dcd5400678f408805"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    foo = testpath/"foo"
    bar = testpath/"bar"
    (testpath/".config").mkdir
    (testpath/".config/safe-rm").write bar
    touch foo
    touch bar
    system bin/"safe-rm", foo
    refute_predicate foo, :exist?
    shell_output("#{bin}/safe-rm #{bar} 2>&1", 64)
    assert_predicate bar, :exist?
  end
end
