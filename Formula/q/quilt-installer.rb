class QuiltInstaller < Formula
  desc "Installer for Quilt for the vanilla launcher"
  homepage "https://quiltmc.org/"
  url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/0.14.1/quilt-installer-0.14.1.jar"
  sha256 "4d016064beecd85e28b841ebaf7bfee45576dfe494a791de6ddc2aba1d10b8e5"
  license "Apache-2.0"

  livecheck do
    url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6ce48f15024fcbb72e5bb64d7fe3064e8c1e25e801dafae2c867bc936c6e80e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6ce48f15024fcbb72e5bb64d7fe3064e8c1e25e801dafae2c867bc936c6e80e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6ce48f15024fcbb72e5bb64d7fe3064e8c1e25e801dafae2c867bc936c6e80e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6ce48f15024fcbb72e5bb64d7fe3064e8c1e25e801dafae2c867bc936c6e80e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9f5988ff049eb25c4042d38455d0e7b4a3eecc56227a24fa982521e6237f235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e18e840f6bc009cd007cab530765509e42d73b4059d21eecd38bd4ced460061"
  end

  depends_on "openjdk"

  def install
    libexec.install "quilt-installer-#{version}.jar"
    bin.write_jar_script libexec/"quilt-installer-#{version}.jar", "quilt-installer"
  end

  test do
    system bin/"quilt-installer", "install", "server", "1.19.2"
    assert_path_exists testpath/"server/quilt-server-launch.jar"
  end
end
