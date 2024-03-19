class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.218.tar.gz"
  sha256 "9cac8fad1187a093dbdfcfd3ddd7d701e8e3cac12aa08b2fdc7e6bf835b91c82"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "327db7894ed15c4dc0bced2942fc433e6487ccac34b06872d87c84574d7b0943"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "824a0805f9d769c8935dfe3fdbae2fc0593fd1562f3d7f7971a48bc9e369abf5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af54fcc30602794e12bf9629db88b8573fe171c8acd72e496272eb9d566996da"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4535f133d2005a9fbdc9f24650ad08a26d49b8f70f87504b744b9f3f8706732"
    sha256 cellar: :any_skip_relocation, ventura:        "9b232d998846589c61f6beeca4468b91d51e7c23181a87780e317aa7d94d9ba9"
    sha256 cellar: :any_skip_relocation, monterey:       "76ac3f91b37b9a37a82a011aef4b336cdec2cd0a5b442df1d8390ed17127df58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab0ff35c14f5eb674039a0b767d81c6ef4def84374ceb08dea176a6ba95ce9e4"
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
