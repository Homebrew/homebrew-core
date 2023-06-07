class QuiltInstaller < Formula
  desc "Installer for Quilt for the vanilla launcher"
  homepage "https://quiltmc.org/"
  url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/0.5.1/quilt-installer-0.5.1.jar"
  sha256 "8bcb4381196fb7a881c60efac7631ae6b8bf40dbd814563fb716a8ac92364cbe"
  license "Apache-2.0"

  livecheck do
    url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5286db63753a8607857d423871a6745d404f2994f3a48db1b4a977a4137d42ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5286db63753a8607857d423871a6745d404f2994f3a48db1b4a977a4137d42ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5286db63753a8607857d423871a6745d404f2994f3a48db1b4a977a4137d42ff"
    sha256 cellar: :any_skip_relocation, ventura:        "5286db63753a8607857d423871a6745d404f2994f3a48db1b4a977a4137d42ff"
    sha256 cellar: :any_skip_relocation, monterey:       "5286db63753a8607857d423871a6745d404f2994f3a48db1b4a977a4137d42ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "5286db63753a8607857d423871a6745d404f2994f3a48db1b4a977a4137d42ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c505d816a0933aaa4b96762998744badd7f162ff643a284aea593ef5155f20cc"
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
