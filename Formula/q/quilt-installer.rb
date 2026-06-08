class QuiltInstaller < Formula
  desc "Installer for Quilt for the vanilla launcher"
  homepage "https://quiltmc.org/"
  url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/0.13.1/quilt-installer-0.13.1.jar"
  sha256 "6e1bd14860f30e74a5827ba9dcc8c201a0c64f700421670c4bc7c436baca2747"
  license "Apache-2.0"

  livecheck do
    url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db9fd5e9ee37465c3819a1393b69fb55386849f82cf13be2992a5cfa504cf166"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db9fd5e9ee37465c3819a1393b69fb55386849f82cf13be2992a5cfa504cf166"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db9fd5e9ee37465c3819a1393b69fb55386849f82cf13be2992a5cfa504cf166"
    sha256 cellar: :any_skip_relocation, sonoma:        "db9fd5e9ee37465c3819a1393b69fb55386849f82cf13be2992a5cfa504cf166"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8557446698c164cec78956b5aab9ea74fc0900412f0ad3f113009d15e9acdb5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8557446698c164cec78956b5aab9ea74fc0900412f0ad3f113009d15e9acdb5f"
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
