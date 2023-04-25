class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.173.tar.gz"
  sha256 "96403e34c10caf2d277ffcaabb20b9d56c60d76797243a4e22b99d861042beaf"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62c11c33cc6df93f92610ffc92231aec5fd63e4c26a58b9ec6b55eb3bce12b60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f440c0dae03dc11c06325f90a96af36ae6d96f66e0d0527aeebe7ff527d1af3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ad4d8eb055ca9cee44509049f7cfdd4a38cbcde6fd87fa17ffb3f8f434f0779"
    sha256 cellar: :any_skip_relocation, ventura:        "4a72526c6031d2aa51677fbe301316a249ead94775de3a72f4b411b8fe1c47d7"
    sha256 cellar: :any_skip_relocation, monterey:       "b0be08b8452fab2d79079bbd797f076c2b1df408182b4c77af14fabd2f0c64b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "02fde7a93da0499610a511bef86cb269d6bb66a2903c2744cf6ae978d58655cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f379085b8e894eef7097719a0fef84090b306ebdaf5ced7ff3fd25ec3ce0e3da"
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
