class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.228.tar.gz"
  sha256 "e85bf6087b501f96d68a4d37c4d3e298af38057640cbd62f6467ee2e16b61068"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db6b42ffcc52cec0df0d64a0b0e13a690b9c18b04ff2e3c03f2693193093f6ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f827439c93b5155aba55d0d673276193f29c0ae5a18f2bd13d2d7ab2a08cfa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c7ec603a48ce7bb2793494115d64a036a6466ae3dafa93c8bf71a309e5135af"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff85379947e036f79c52260c7b65496ca883ea36052f29e59c0f44d27fce9488"
    sha256 cellar: :any_skip_relocation, ventura:        "7aeecedf2e94efb8a079868faf973ddd258262ea009b809d9a73a9c1e58221c6"
    sha256 cellar: :any_skip_relocation, monterey:       "bf983c800205a9c11b49d45ed0f98ec3870d024d6e5db797defe43e2e2e83fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6a2b43760b3b1487ba8a124315cadfcfa0bee7594233220784be217563f55b0"
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
