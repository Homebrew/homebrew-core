class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.149.tar.gz"
  sha256 "ceff053b058114d087360d20e5047f9ca281558b1587d0f5396be397b0b4ea7a"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4a9b2c26c251137bce4e7f6e1154a606b086e3ffc63fe74e099d42d94bd00e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "484226b34fc92eee89fe9e33f6061beda5b84a3f25cac1069a72a88b977f00fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da63765f6551b24f873ab19d1b982ce7953d27dfee6f8e2764e392fa4019146c"
    sha256 cellar: :any_skip_relocation, ventura:        "d4b6f546173280f714b2cd708c7e2cb5dba9242dcb82256a357b50c950d4a231"
    sha256 cellar: :any_skip_relocation, monterey:       "af284e61049688a751a1dc0edb821da61be45cc160216a7bffd4fa27b1876df5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9572b46d4f50df04815bfb33c4163351e7f55126e7873b43bb7326eb96f32e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea6e1488e7ab88adae8b54723bfeddb8bb2204771582b1a116cafa792de6d44"
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
