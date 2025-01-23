class QuiltInstaller < Formula
  desc "Installer for Quilt for the vanilla launcher"
  homepage "https://quiltmc.org/"
  url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/0.9.2/quilt-installer-0.9.2.jar"
  sha256 "c3ad3e23eee860e5185c594e7cb280e4fabe7e766a83945381d9a99c64855c5b"
  license "Apache-2.0"

  livecheck do
    url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9d76f93e7f4080f45508942471391f95140785ccadce9e804d5310ec094ed6df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6eb2f59fd287c6438034f837f7587d8b6722e8047d40635640e8440c5e811fcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c81e39b17984d71015ed187fe5fac096c858d1a67043c5af9b84f174831de5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32636008188294029e0d28719651aa98a3853827287bfa13bed7531afe3d7ae6"
    sha256 cellar: :any_skip_relocation, sonoma:         "a44456545b18c184ddb2a71c2a971c49fa0a957d0a6fc251406f148031c677dc"
    sha256 cellar: :any_skip_relocation, ventura:        "3ff90897a10c506d2041a01c3ec5b728908392e4123df3e8bcbdea8361c7536c"
    sha256 cellar: :any_skip_relocation, monterey:       "a5e6dd75b9c4422d0ba8bc4db0a2ace2234b86181fa565f9e3eea6e372566ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c5164ff3aa3532538643aae4c3f4eeda92c575128eefe672fc76fa22a4e9438"
  end

  depends_on "openjdk"

  def install
    libexec.install "quilt-installer-#{version}.jar"
    bin.write_jar_script libexec/"quilt-installer-#{version}.jar", "quilt-installer"
  end

  test do
    system bin/"quilt-installer", "install", "server", "1.19.2"
    assert_predicate testpath/"server/quilt-server-launch.jar", :exist?
  end
end
