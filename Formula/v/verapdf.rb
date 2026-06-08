class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.30.2.tar.gz"
  sha256 "77dfc85544b83784ba4a9d2807bdb3f194b0c22d83904ecf222054ddf10a5347"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468]\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0777676af3574208da83ded887a52621c70e0a097f846c4a0ef2abaafbe1f1d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dddc5159ea8fb6dca099a3603dd1a0282342930fda3929b53e114ba49888fdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5013d8c30f5c8ed497c5f4e114a48934cb5adce5587210346e8b368aa36b62c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdb9eb31e0d5201d96e3dc88285d9fe2f6766f9766651cf1d4540c659ee337a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f5cd64b1d7119058d7906ae65de57f505f77972e5b8ccc24a852d33982fd666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "336018e296fce7322e4e9c44793f779e198875a32d52c7f7129886242610e933"
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
