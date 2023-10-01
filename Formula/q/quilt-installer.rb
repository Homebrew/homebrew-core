class QuiltInstaller < Formula
  desc "Installer for Quilt for the vanilla launcher"
  homepage "https://quiltmc.org/"
  url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/0.9.1/quilt-installer-0.9.1.jar"
  sha256 "c4bd6300b883e406a15490f9c36059ec3057fc28b4f5b858e0e793231d0b4fa7"
  license "Apache-2.0"

  livecheck do
    url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34772e07f6c1b7e48008b991b7ba08cc4f7f35c997608e98699126c79c2c528a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34772e07f6c1b7e48008b991b7ba08cc4f7f35c997608e98699126c79c2c528a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34772e07f6c1b7e48008b991b7ba08cc4f7f35c997608e98699126c79c2c528a"
    sha256 cellar: :any_skip_relocation, ventura:        "34772e07f6c1b7e48008b991b7ba08cc4f7f35c997608e98699126c79c2c528a"
    sha256 cellar: :any_skip_relocation, monterey:       "34772e07f6c1b7e48008b991b7ba08cc4f7f35c997608e98699126c79c2c528a"
    sha256 cellar: :any_skip_relocation, big_sur:        "34772e07f6c1b7e48008b991b7ba08cc4f7f35c997608e98699126c79c2c528a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11796b3e945ef4f3904a271feb4e1aeb5abea87729443695e8a31be2eea78542"
  end

  depends_on "openjdk"

  def install
    libexec.install "quilt-installer-#{version}.jar"
    bin.write_jar_script libexec/"quilt-installer-#{version}.jar", "quilt-installer"
  end

  test do
    system "#{bin}/quilt-installer", "install", "server", "1.19.2"
    assert_predicate testpath/"server/quilt-server-launch.jar", :exist?
  end
end
