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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbae6f8987f4179f7ad7ca597ce8cc22510578be96612a3c98fbeea5abe96ba5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25d9502450022e1e7a3145e783827f96f82c597671a22a4cb91a4d03267b33b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9225f5e2d89debd75e186bda22d8459fccd2897ae1a87ac79a412641d1826573"
    sha256 cellar: :any_skip_relocation, sonoma:        "294e4d35454edc87c8a4425e213f2afc02d7c629b95221c9d74d25aa553ae3bc"
    sha256 cellar: :any_skip_relocation, ventura:       "5044cc1f06ae5d32fe6c879798cbe5c63385042c7804611413dc99e037da848f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "372c94906bf400dd729456396c5147d464c6426d908c43e22532f73a196e3e62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b4de9a77c593403d7924e13c93326568811b62986b2b0c53c986e5211d48efe"
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
