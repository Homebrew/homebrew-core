class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.229.tar.gz"
  sha256 "abd2cc8bd6cc4fb9a68397ce6060aa7ce0e8621a76239c7e269ab03a0ecc3f37"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48fb3524191a70e1cd0ddf50f3c2b712285c61300195501a558771d2bddaaa99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b83b7453679684e53dfc827af3e5b8ef83888b4d20ff52fc8e80934e4d228844"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c679f65fbef513c67e9553164a0e9416bc25e9fb3683aa59e246b7a2ddeb0ec"
    sha256 cellar: :any_skip_relocation, ventura:        "a4d86e2115f6c68815d700da6e706fc081f1fca8b3c979018a01104aacdf45b0"
    sha256 cellar: :any_skip_relocation, monterey:       "97f19714de59c02cf604c78c9e0eea555413e0dd45900c71d75a3eb3a72e239c"
    sha256 cellar: :any_skip_relocation, big_sur:        "45968d4f26f09e0e1ea614733a95dfe744c9f0b80c58c4ba52a378a6c7a1b255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b189763c8d8ffcfee3f618bbfdf125e5167b557cecf9a232cd68f3242a283f11"
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
