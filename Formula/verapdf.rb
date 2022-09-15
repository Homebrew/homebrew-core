class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.22.3.tar.gz"
  sha256 "d5a83444c79870adeb7ebf48aef685943c90458637344342c21f06df0e04ec93"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  # Even-numbered minor versions represent stable releases.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468](?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95a2266e2f0b9dc0b50cf8363c53d793ec881e0dbce1fa752ce242cac9b6b55f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f638ec0317c74ccb17bb44fdffa5b2e4c1820b061f8ec4c90d730d75c816bc3"
    sha256 cellar: :any_skip_relocation, monterey:       "1da748cac0e4ab29f372c2f8dbf441d79bc59991ac76535d791abb84f61fdb32"
    sha256 cellar: :any_skip_relocation, big_sur:        "9243f0befca09bf3a14400085a134516393665ef3f16d84da6c58ce46b6f8a4b"
    sha256 cellar: :any_skip_relocation, catalina:       "c813cfcde5c3f5c0ff102f34b8cfaf99b3209e253d52cf9ce6472414a7bc83ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f300e2830f22d602f6e0c758af0d14a9c946d57aeb259d5014e14cf64991b45f"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    system "mvn", "clean", "install"

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
