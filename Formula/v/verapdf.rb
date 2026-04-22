class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "eccc9745d08f9096785712498a479ab1a9f772fecf10f5e62cf7582670ed4776"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468]\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea9d7f18979e35c99b61c546589905727685bb19cd34585dc7806b6093bb022c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2b1facb9288e003c92eea3fea1ef80ae4c0ae1ce1082df08743d1732cf773e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1be4d2d3e1839cbaee8be2cff9d9e1c96d8873b4fb1d45a30be9eb5943899942"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2e6a315b08158f5be6ca986abcd3bc6073a36574e3fe8963a1042483f2674af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80090fbb7e9f9ed3375162a78e92927386e53e451a7983eda43b21cb53c00a15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d53ee6eb4fba0b8f4c1b8b77c3bfb249574d56cc12fe0665fd7d9aa818ded83a"
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
