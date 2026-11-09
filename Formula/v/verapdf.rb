class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.30.4.tar.gz"
  sha256 "306343acfb2ec4686460f7fcf755e0c1d18883106f052dc64989317bd0480253"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468]\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "38d27f278d7bfc58ba5dae932e6564e2fe859961e0bab31d53365468a7330b7b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b75306d0a3543a7fba70241ef295a3743911d1fc45d4aba53358946e2f757357"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "758fd615119ba60d715edf48d4c186e5e9e37f44d470714d9453574d7a292435"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c954b84b175ea7705964985721d8271ba0b42e8f7dd854aa3ff0bc2c6747ff7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cef74906d8577f600271757cbd2c6383a2a3acd8431e65a766be30aa53be12a2"
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
