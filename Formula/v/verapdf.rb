class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.97.tar.gz"
  sha256 "53a1211fbb0d96a7d04f86ecf49159676d9b19b547739325bae30e73fbf6ed49"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9cfb5c2861ba5f4134d50ff8f5af0edde9bd6634b24a08ebe1832ec3626ded1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb166cd7f8f5643ee531d93146d47c60730a18ecd206a7cd46807c850c2ac8fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52d9523c16f728c06087e00ba0e14ea1f267a015abc876e575e2c79dc0b8caed"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9f04a0adfbfeeb240e4da67312e23787d339b5994c383c6956d108bb2e82313"
    sha256 cellar: :any_skip_relocation, ventura:        "676f300b99a288512e0806f47a642bd647f6f1145ae228642bf2d1b168fc46a2"
    sha256 cellar: :any_skip_relocation, monterey:       "632a5b82a625cf6a467458c8d0de9c0df1ecc8cb38dc024845236a44de6e274a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e6760d86da1f52f206bcd0fbb56d353efb3d96b47b4e0d47187396d380b56cb"
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
