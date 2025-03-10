class QuiltInstaller < Formula
  desc "Installer for Quilt for the vanilla launcher"
  homepage "https://quiltmc.org/"
  url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/0.12.0/quilt-installer-0.12.0.jar"
  sha256 "14b4b880a9bd48d2eb585f370265109fb191d1fca51d22eb9e7a31f203daddc1"
  license "Apache-2.0"

  livecheck do
    url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b0e97a729b329cd0490501e161907b2d6cd8460bf8fe31dedf0369aa0f14cd70"
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
