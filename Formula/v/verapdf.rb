class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.221.tar.gz"
  sha256 "96990ddbbf56b59b738290891b136cb59cf890a4b1ac3227f940ca696c7579d2"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fa7d927dcfb05c7190da73a29870008144e6fa85d439287dc215d708670006d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad156c5550e74f6dd35b4fe53fa4772d43f899c019950bf2cc69567d66e15bba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e0330a8461cdaa76ae8c1e0c3b839588a69c1b3299d2df7ad66dab47995be90"
    sha256 cellar: :any_skip_relocation, sonoma:         "5084df20290486ae2150bc7155983d633e227c3c7b583034e48f9e559fcfa27e"
    sha256 cellar: :any_skip_relocation, ventura:        "0471ac5a2818978bc0df87a414136859814b32bc54d14d49ca3dbbbc7c3fa626"
    sha256 cellar: :any_skip_relocation, monterey:       "0e96bc98696238b0165f25cb27ccbe821d7fd426d5d6f9f76893707f21f00270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3202e959e8a866dbc0a14575335cab168921453a87f02b6075d16fcde8d99d1a"
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
