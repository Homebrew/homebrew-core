class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.151.tar.gz"
  sha256 "b26008ea623ab40cc576e0f717093b8214410c73695cbbe4115a8e736ac4001e"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a65aa3fa9f3e29ee4334d6e50413c369160560edc25e42e90ef91acbd5689919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f739ccb98b78a2b9cc6374cca8f489fdc466e4ef5fd13290973dc79ee439d52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d5bfed4c79d6b70c1e0c559cde2d375b5832690e98a30bbe5e867714a3a75fe"
    sha256 cellar: :any_skip_relocation, ventura:        "27ba25780ba9bbc4843a76680e494964ce638d91eca1d53030fd40accc7efb08"
    sha256 cellar: :any_skip_relocation, monterey:       "a10c2d12558c1fdf588d32b002b8084b65b1ba03699edc64ebf025836ad5037b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c072b2f0dc597399ef81bcce400fe68f037aeaf06efa8c532e1e744026d7402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f0e5926067bd89e136acadce5361003daf9898f8794019571bbb1e77931b41e"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "mvn", "clean", "install"

    installer_file = Pathname.glob("installer/target/verapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec/"verapdf", libexec/"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env("17")
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}/verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end
