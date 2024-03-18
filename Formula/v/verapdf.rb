class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.216.tar.gz"
  sha256 "4922c28e42e60c7348ccb01b6e9a1ac0d2fa206e6dedff6cd3c149a5dc207fa7"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd594bef6384b52cbaba63d0777bcea3e98d9781218af93c246b55fd535688ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1730d852fb515df525db3873b7cc306d1df200a4f2c5903dc7d2e91a6db1136f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3942c289fadf85f879f46b14ae425bccb5420eaf5d41d4f747d7817a914e2968"
    sha256 cellar: :any_skip_relocation, sonoma:         "3cc1c4e74d04905f5db3b6a40fda3c9d7c7b89d34007138eb632f8edd82c0805"
    sha256 cellar: :any_skip_relocation, ventura:        "6ca8dfdee0d99f61d800681e72d904d7d24a77979c5a24d1bba908d7e83e70dc"
    sha256 cellar: :any_skip_relocation, monterey:       "8fc18e35ffe1c6240fb341a8728a36a78749b69c01a2288db585967a47bf92cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d4ff667da2aa903df380ff3d11a22cd27a4213e99725f178d054ba26b8eec02"
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
