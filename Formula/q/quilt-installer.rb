class QuiltInstaller < Formula
  desc "Installer for Quilt for the vanilla launcher"
  homepage "https://quiltmc.org/"
  url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/0.15.1/quilt-installer-0.15.1.jar"
  sha256 "0a229138caa1b87fd8f5622038410696f98bb85871a279640e7002404c4d0dc2"
  license "Apache-2.0"

  livecheck do
    url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edbaaae42ff29fe6640cdf3952215015b4eb909a9789e3f8917b3ca92c4953c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edbaaae42ff29fe6640cdf3952215015b4eb909a9789e3f8917b3ca92c4953c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edbaaae42ff29fe6640cdf3952215015b4eb909a9789e3f8917b3ca92c4953c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "edbaaae42ff29fe6640cdf3952215015b4eb909a9789e3f8917b3ca92c4953c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75cd784b7fea2fd41979dd91da1a7b807c9009081bfa9486764aab4db1338278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb873d72440be9e7ec451595ff70636543882581fc95f95daccd0f41aa196ccc"
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
