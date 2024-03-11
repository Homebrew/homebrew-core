class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.215.tar.gz"
  sha256 "03525e79c2f3958ee5b8e064b20db24226ae1eca8125174094cbe1c27abc67fe"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13e6381d138128d64794d5a7ddbef9b1c6eccfae5bfbffd771d5f3d49a62bf58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "716cbfc8e48dd5f762f636b0971fbeb18b4c093436835f2b0a6342cc1d0849b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "988d823d18e553a7282ced97b5dd26d3d2596e256fd2e96e799d6c88fd9b2786"
    sha256 cellar: :any_skip_relocation, sonoma:         "db32ce263edc80137b8dc99f57ac113c10702edea4abad107c5f55753c36710d"
    sha256 cellar: :any_skip_relocation, ventura:        "f0efccef871f67733f7fc0a00f99738ea68ceb3360e9d46ca1ab7f90c6e8816e"
    sha256 cellar: :any_skip_relocation, monterey:       "a621aece46e758f2fb642f4a7db27acff4a90a92f4128741b9760ebfa90f651a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82fc466adb9cacec92b67ee057f7775a4134f0329352554d084d2b4055259346"
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
