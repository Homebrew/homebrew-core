class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.26.5.tar.gz"
  sha256 "86a75321defc78c2027a86cbb117ef0011ec6b876de58705c5074965fb3af932"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468]\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "421f58e1c12ca320726e62f858107bba6fbf83ff40f1218d2edf939fdb55dc85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31fdef7dd908c4029bdd9b6e2a1aa8eb1b0b7634563edbf584f97f16eb59a494"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d037040888b3555e6f139c1278f19fc288601aa84ae80085104eb0f89ab7b71"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a81bacaef4bd6c9a71ac84c9506db0bc0a96357ba4376913b07cd3bacaa1443"
    sha256 cellar: :any_skip_relocation, ventura:       "69a982bee3a812109c8424b0b2555f69850dd8e8e0ccaca9abdec300be972398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1066fbf01e66e75e9aa4cea5e973134e9a480118bcede71a544c6ab8b6d118e5"
  end

  depends_on "maven" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix
    system "mvn", "clean", "install", "-DskipTests"

    installer_file = Pathname.glob("installer/target/verapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec/"verapdf", libexec/"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env("21")
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: bin/"verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end
