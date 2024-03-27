class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.228.tar.gz"
  sha256 "e85bf6087b501f96d68a4d37c4d3e298af38057640cbd62f6467ee2e16b61068"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c379d1e2fca3f757693c5441abe053553e365d050a52f633c8be79d5885b419b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35348897257c79e111d5ae5076baf9658a6aed199cfc2df4ddb345e359afaeb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6cd0b6a69ed717f27aa5ca4522b8187602b324a4e03c1a09684440c2dcc49e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "29671778d9967e51ef0de512e7d9b5223001887bd635d61aacb23a9e1c2faf7d"
    sha256 cellar: :any_skip_relocation, ventura:        "9e95f5ea171774cb266b7d72614aa73ec259512d0df7ede4de0da54484f41091"
    sha256 cellar: :any_skip_relocation, monterey:       "eacc2d7dc46f247ebd1fda99489816f8e1e31ec92ba8a95dc5f1c0d76b021a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06fd94e5936ea11dee0abb959af2c63382bf47445262bb98b9d4d1be260a49e1"
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
    with_env(VERAPDF: "#{bin}/verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end
