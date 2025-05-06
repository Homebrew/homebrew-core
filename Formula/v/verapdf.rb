class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "893bb430b05a15cefdc31c8dec036142da94f9d2c5b7ab572a081f97205cfd24"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468]\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a956c37fd5e13d495ed1c9d16d81899b9aa605598a695259e1361c8ac7ed8f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "446e11ce78770ea8ac46b3a9e2bbdab1398fcdb31a12f168661881a11f672039"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8cdc4d6507e0189dcd0e6c765d0eea68fc15ed80c36da9cd166c8816db48a086"
    sha256 cellar: :any_skip_relocation, sonoma:        "84114507be187d60832f31848975a383a527da4ae1490a39dd62e34c635693c1"
    sha256 cellar: :any_skip_relocation, ventura:       "39fe874dacfcb08d49e49e456e1180ecd705891489db4afc9045d8aaa9a179c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24fe59400c8855a145cb62adf851dcd3a3508b1ba6006a8fe7f18977450ff3ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d45fa16ad1cd67a9819f16870e87e5ae5e228ea6f57210068584e20890fb0ccf"
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
