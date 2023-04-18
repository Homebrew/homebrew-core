class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.171.tar.gz"
  sha256 "8f0e5b2006df20cb967e202e888556d4b3a68f4227a03218110927951d9c6515"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb4dcfbc079482f50a410d46a3e8f3a15e74e8faddcd690a25e9203ffa343256"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e60514fc40dc4b682fddcd302498a8cd545a1a74b137d383ccbe1a203621e57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68983da9745429976b5a6846588e70a350b2be1904a08993fb3252d5bea856c6"
    sha256 cellar: :any_skip_relocation, ventura:        "bbc670de86cdbbdd680addc8b0b273c25b81589a691bb2a1de72a469fac7dee3"
    sha256 cellar: :any_skip_relocation, monterey:       "0e785db056414228217ac88c53f2f97496259942ef470b0f9e71426b2a8719c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e3a9830648bdaf6c31cd50e556d49d478bc4c88b0511f1eaa024d5bc43fe028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b6aee5e17da5e0ed5a621e90325b236d9be51c5d441ad90d95dcaac23754566"
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
