class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.219.tar.gz"
  sha256 "6be791588e5796b49560a1395cea72d21a81d1ae59b198d446c05b3bff6fb910"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e77db9df706e0e1fcda4dff87402610f955ac9e33e2b153d9112dc2fe5d3401"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f90bce2739b0a9ab681011a47022d01d2406f6d79eb18ef74646fc7fd69f81d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab9730c8c075c7da8f93bcd35badc54a49c101dc215470de1427df61bb16ba62"
    sha256 cellar: :any_skip_relocation, sonoma:         "dac982b52df881a8f1d487d11a9f6acbf4906aad510ab360f1b6f4292c2ab8da"
    sha256 cellar: :any_skip_relocation, ventura:        "1c30e418f0fb9eeb3d298db9d071921094ec0a29362b1cf2866a5b07b589e223"
    sha256 cellar: :any_skip_relocation, monterey:       "33627ed62eba3254ab7c61c02e078f0a37c87f5c967bd395030070edbb6e40c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b0fe245e412127fa4e318e72af2c5a4ac9019d4814d44aa5d42232747fd5ae4"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "mvn", "clean", "install", "-DskipTests"

    installer_file = Pathname.glob("installer/target/verapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec/"verapdf", libexec/"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}/verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end
