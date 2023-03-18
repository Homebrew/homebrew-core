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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b483bda6032cc697bd210252e9e42fe1a39c91e0034f030da8819adf08a46ed0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ee2d0fee3cdbb8e6febca6504ada1f20388b89dc98b8421611d82dddc513945"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66cef5530a553ecbf5804ea2eb5d3658cc3c71501acaeb8a657eaafafc9f0df6"
    sha256 cellar: :any_skip_relocation, ventura:        "157c23c6862078c30b9897f59b6f127ebb75aa3ccc837623d0b03d35746813fe"
    sha256 cellar: :any_skip_relocation, monterey:       "388edead30bfae3df926bc021e7213768c06e54bdf5ec0d77023dbd6e6a17741"
    sha256 cellar: :any_skip_relocation, big_sur:        "a270c8d5f60e8adaa3632fd4bc58c9c6b6c9e5f634866c3a63fb36159660efeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b93f152e0423c2fb0480e6d8d38497bb6534c3d1d38013e5c73eef489d4076a4"
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
