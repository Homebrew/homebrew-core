class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "5ed7463a0d19068932482c19b632c58c315a9019d430d63521db9b51928e98dc"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468]\.\d+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24ca96475da31f494fdd0bd424c7b28766ed0b87892a139957f5138a3a8d906a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dc146bce3bdaa86a20a2341bc8d30a55666c7c917ab62dc80112af1327848ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e564f8727689aa8a37af740a1e751bacaa9b4620104dccc9952bc5df507fa13d"
    sha256 cellar: :any_skip_relocation, sonoma:        "eda37a76a20996f537208286b4764c4760271ede453685471415f599891dfefa"
    sha256 cellar: :any_skip_relocation, ventura:       "3981a1b0721d711a9c12798221943cd0a8b806e25e348cdb8bfe4bb66e9148e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d414f29e363d672734ffb8955fdc1fb7393ed91db970f2664bccee4c98fc450a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "883423aa080dc5a92ee5e7c1427f689e5dbb52456d076e9e06c1e3ee241af8cb"
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
