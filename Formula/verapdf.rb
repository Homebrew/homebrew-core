class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.22.3.tar.gz"
  sha256 "d5a83444c79870adeb7ebf48aef685943c90458637344342c21f06df0e04ec93"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  # Even-numbered minor versions represent stable releases.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468](?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15d9156715d4d1c779886570ce82439240ee9113e5b75e1cf01e023942b0aa9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25a43317ec19035cda93042d320432e6bcc05c0b03fb28331f0d8d5b48ddfe37"
    sha256 cellar: :any_skip_relocation, monterey:       "2026eadc1fff73eb60278bed7d0c159fa07e07f5e99b10d7e82a00155ab07dab"
    sha256 cellar: :any_skip_relocation, big_sur:        "2978df601e5192ad9a300e28769d3dc1e4e4752228e0e0b278a6c5c25480eb46"
    sha256 cellar: :any_skip_relocation, catalina:       "0da78a2568b0db05cd5fe75e4c2e05771bc7ecc037ed0284bb4d37a853f93fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "add861f4080e09847c2e3b22d5a1f4998c30a63fa7e2ba96ad2079f196c38ee6"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    system "mvn", "clean", "install"

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
