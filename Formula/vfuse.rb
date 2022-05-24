class Vfuse < Formula
  desc "Convert bootable DMG images for use in VMware Fusion"
  homepage "https://github.com/chilcote/vfuse"
  url "https://github.com/chilcote/vfuse/archive/2.2.6.tar.gz"
  sha256 "fbf5f8a1c664b03c7513a70aa05c3fc501a7ebdb53f128f1f05c24395871a314"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8184d1fd9ed9a9053df739ad09fa721686131c8a6c2a13b294aec564016cf19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8184d1fd9ed9a9053df739ad09fa721686131c8a6c2a13b294aec564016cf19"
    sha256 cellar: :any_skip_relocation, monterey:       "95be83b370683ec27d9052f897028bd939241568d81939a67d3bb985d89a06df"
    sha256 cellar: :any_skip_relocation, big_sur:        "95be83b370683ec27d9052f897028bd939241568d81939a67d3bb985d89a06df"
    sha256 cellar: :any_skip_relocation, catalina:       "95be83b370683ec27d9052f897028bd939241568d81939a67d3bb985d89a06df"
    sha256 cellar: :any_skip_relocation, mojave:         "95be83b370683ec27d9052f897028bd939241568d81939a67d3bb985d89a06df"
  end

  depends_on :macos

  def install
    # Fix upstream artifact packaging issue
    # remove in the next release
    inreplace "Makefile", "2.2.5", "2.2.6"
    inreplace "pkgroot/usr/local/vfuse/bin/vfuse", "2.2.5", "2.2.6"

    bin.install Dir["pkgroot/usr/local/vfuse/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfuse --version")
  end
end
