class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.30.3.tar.gz"
  sha256 "feb399e0140a13b743144009e6cde61625c08dd15633d259ad360788d3b5ce57"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468]\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7cb9987474b55c0e9974d6b4189b181c620d1417b41831b558d817e15e0aea39"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e2d9ad4654281dfb6519e386e143f9d2d0c85b79fc1c6d28eb8f0eccfddc1a84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ca7c9d6ce1f535be641a9d2b6cb8991bd4b7403cf0be4b57e88b2d2c55d71f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "01677fadc649a4077ab2b3f5fbcb34432a3ba7ae181072119bb2e3077e5b6aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "96b282ac2c81e5619d5508eff06c3df2d5ff3c336c0f50f4c381382dc20e2e32"
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
