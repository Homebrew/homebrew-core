class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.28.2.tar.gz"
  sha256 "48225e1b75d1dc1b9c87b845668bca37f9628a5a0a0010a6a8b55c8b332c3462"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468]\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cd84926712c2b06d9aa5500a6577809256e1b3c5a7690dd6af807c6e8e68f01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e4ab904561e91dc5a727f1aef5b92d6375b511453853da22e1a8bd8ff3f2a5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe5e4c7241fb3f4cd5b0b7d3ff6da79dae60059da3e8374707c7ec99b07298f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4d47eba52e8321865e0a87cd8cdb849803af7dc6791c75a2d9c3b0636f56c54"
    sha256 cellar: :any_skip_relocation, sonoma:        "320b07cb60d7dc030d16fef2c12417e2484d6fec0452e1a2d60455946531f9bd"
    sha256 cellar: :any_skip_relocation, ventura:       "036f34f42ac11286ecae531cb5b5f9ccdbf4fa9392a190c33a94abf1a0ddf982"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daf107c8fed2ce3613bdb98afe21304efa0d69566f96ac8d83e126fbf12f43dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "549f11f668ca6a791fb4ec44ef80774ba65eee9b218c9994e194bc3ab2a2f06b"
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
    with_env(VERAPDF: bin/"verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end
