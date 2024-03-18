class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.217.tar.gz"
  sha256 "ea489cf74819e62c29818191d2c7e093a9a4d376d26f9ebfea699abde369f9e0"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f9dd52138ad717da7c8a6ea2bf36e8abdac7311395ded84cc5ff7cf88b4b563"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "546f0f4b4ca4fdfdb78aee87120f4e60d1563a481b7fe5e430088d038a1d2aaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46fab0cf240ba310a221898b166011f28ed218244848d63e1550fb050ce779d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f208e76e9c42a9cbc6fbb086365376984702e157f28e0b097b3c32f03ca8432"
    sha256 cellar: :any_skip_relocation, ventura:        "86ccc317b450dc92b57a193da48cdcaefc59d889eefab7161ce608d90365cd9c"
    sha256 cellar: :any_skip_relocation, monterey:       "68e4448f9e1a28fede7332cc95c2ff63334373e3ea32f5931d86b605b5ea08fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18454cae7ff14bf13361f4e24d162ac043b55abd23f7adac99925c6038173c5e"
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
