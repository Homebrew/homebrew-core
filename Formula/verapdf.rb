class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.235.tar.gz"
  sha256 "8ee9b52554871b71588717a9135d4695135d1a175b95384322fec2b65ed06388"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c83f8eba7c83958542239c155d3c8fb2db45704a51dd4782feb42933fda600f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8c57d3d2dfc24551da5a40eb6a76c174db9ad065bead8c85100af9ccd4c52ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3a1dbd91724b80300f3ef04c8248365dd9f97b761d61ee5b88f4f49e54718f5"
    sha256 cellar: :any_skip_relocation, ventura:        "640288f7c843d716a719416fe5d490b6b2b7a9658b81fb289f2770ef32b164e9"
    sha256 cellar: :any_skip_relocation, monterey:       "44bf1b26861cf520faa9df7ab3f16fe9b25c4cc07545c80c032977a3c9789daf"
    sha256 cellar: :any_skip_relocation, big_sur:        "0113fe85ee425adc3c0632834d77e28c49f9e9bdf0a63a0bb3c7cda999ba2f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f5a56512d35a6841c81bc1e03446164c86dbc2be7fec2711419bf605b145c3a"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "mvn", "clean", "install"

    installer_file = Pathname.glob("installer/target/verapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec/"verapdf", libexec/"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env("17")
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}/verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end
