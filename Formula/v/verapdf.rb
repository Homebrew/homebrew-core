class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.72.tar.gz"
  sha256 "f9d350dbf5a8c58584181404b9a752ef0ea4a598cfa094262f47f1e4ba9b0078"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4eb2866030828d8167de8df2e31c54420b06de3970f5cce966323a190006ca99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ca5065fad539c8180cc0b334a01166bf18d37993aaefb963566360f6ca92a93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b62c766f9ad01b4a5019ee116ef73eb160112a4606ec515b433504565812f26d"
    sha256 cellar: :any_skip_relocation, sonoma:         "12fb60be5c1e237f27ff5a8920bf2595987422e3903f05ef660266b92459dd3d"
    sha256 cellar: :any_skip_relocation, ventura:        "8dae996795d1e0e0e9362075eb694a76459c9a64dc358b4018b4bd4c9fe6e160"
    sha256 cellar: :any_skip_relocation, monterey:       "e4cac587cd9b46635585a20eb39684df434923e1ed9b0955d0db5c59aa8cf62d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8947d42ca5bff9fc192cdff50a8f516819e266c42273154a5049561b1aa407eb"
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
