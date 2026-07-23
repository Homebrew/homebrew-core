class QuiltInstaller < Formula
  desc "Installer for Quilt for the vanilla launcher"
  homepage "https://quiltmc.org/"
  url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/0.15.0/quilt-installer-0.15.0.jar"
  sha256 "f0c6e04e7f3b932d801b9e783ae17c960ff3cadc0f0109d6cc9be5240e99d455"
  license "Apache-2.0"

  livecheck do
    url "https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f6b4b9950077ac15e7f1084c8e3e80ac53d26dc5c0e0134e666981bf402a166"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a59d3b834c47c82878c4dee762a65e8ec4208651e8798e1709ad9baf02293f50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0188f34f1e642ccf7463cf61872930d5961aee1247ae36df7c8f23f92518bc7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "13ba4f5723ce4d88ce8453810c5371040d788f7228b308116d5953e9aa3d8098"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "589e9ac17b60db5d8a923be5f0ad09df5f032cf781f55a554f53efe55eb768d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd993c01aafc49648843c74142b5bbe926ea6eaf020cf59d42243453ff4b9ec4"
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
