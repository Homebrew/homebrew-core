class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.58.tar.gz"
  sha256 "b33c8f72a28014d47adaadfac499d1a1f6dd60991c42731ea4b0ef8aaa7729d0"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f337683e44daed156f700a0064de3ad5d4ec8e9746bd324ea35f40f9d90c4c96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a58b3fa78d0635d88ad5c62ab9d3215e0f7be40dfadfb0d8694b5681af002e57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "175b27ee540b5ba2ce9c8b3e4267dba959fc7fb3005e914bd50fce6dfdecfb0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f3251ac6cab3b91abc6413709934e647bd230716f09eb4459f97f2f483d078d"
    sha256 cellar: :any_skip_relocation, ventura:        "182587e80455bcc0cee7fe8f3a7d0becd46f219925a6e88e422a6e7cacb126bd"
    sha256 cellar: :any_skip_relocation, monterey:       "e19798434d509f97b9a093c56e6f81a9bb15a2585685c84871ac7106c1d4792a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4f2d841ee089e843c7a2066905ab17337c8c1f7cd19292a3031d70b809a3d31"
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
