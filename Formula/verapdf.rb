class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.169.tar.gz"
  sha256 "9dfe7aabb218a2d41cf4b4e468dfb4af05f2dcb6a2f8d4f15de06d207502b49a"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a325215311192731143557632c0b52bd7b433111d6b3ad6bfdc72a87cfcd2af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6d3a8fb207ea3cc9232be5006785e39f8597021b86ad28437ec6470e8065fe7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29ff6a97a2eabb0780890812281bcf96ae9e567b0f5b3e0c30d408c6be2f7d80"
    sha256 cellar: :any_skip_relocation, ventura:        "5b032bf04481fbc27459a40a75b160912abfea4ce07c043d6b693dfa14ddb83f"
    sha256 cellar: :any_skip_relocation, monterey:       "e3f405fc26300a80dfcf5f6f50c4e771812ab7865362f407c3bfafc13558d969"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7c488c363df3805a3aa9d8578e82258c6d72e7f4fd8ae7c44c2a41136184cd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e1971d2e5a3f7f9de91e2b89031a6ea0e490f87fe7f775fdb24a61db93cc982"
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
