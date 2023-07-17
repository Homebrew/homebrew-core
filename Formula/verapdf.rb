class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.23.tar.gz"
  sha256 "d5bcdb9113079983c01677e5ea75d57b5f404fd6d2b82bddd8ba95bbd7a3f852"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c30bd1e4599b44624db343a05b705b7a4a36cc017fe8ce2b111c302a4ddd59b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3d7d40fb6790448b3550b3962616bc4483be096a0f5688052bc7fb93150bde5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3322109813fb04897da39f056fe9e90e80a79989fa30e8c7e50ea74194a2b553"
    sha256 cellar: :any_skip_relocation, ventura:        "f2d5b6a9d764ced236659afe8ff1c21f40a2130431b896ea5422feb8805a063f"
    sha256 cellar: :any_skip_relocation, monterey:       "704441682616f7931ea25cf49f5e9e42f96bba4b1125b4570ae134feb379998e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cd21ce8e6b456e2e42806ea0282508e1a4a3f0b0c100a0a7f0c2e3c8c81b3c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2812325962f7a1b556d07e89dad5eaee5a7c3c5242ac4118de713339b8de392a"
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
