class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.223.tar.gz"
  sha256 "b75ad44d2320da682b1b01f1aea23f9edd23ecb274849c195f31dadaef88e349"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04502d8515076ddec6cf711e8aed1b605eb51eb21d8b8b9cedc57eca8b74e21d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "894e3ab9fb6039b78dd10946c49a108961d6a9fd206715a8f2bb60ea6b4a3da5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "172ea5943e3f726eb21c9470ec59807cc8341886644662f7c9af6d41feb682a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a31d60d6dab6899578ebdc0dfb5de7b8f9c41d8232281900d941b191f2b04476"
    sha256 cellar: :any_skip_relocation, ventura:        "08a862c43e73ffa1bb12329ae84341d1459139674019fb08972c803a7d3ed89d"
    sha256 cellar: :any_skip_relocation, monterey:       "373dc6dcc91c0a3db8d1b6f2ffd85e1f5b1e619b27c37344877360e916d80202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "393ea959b799d2a2d8217696a5b7deb48889ad6302ea81d1fb9d050ab165c9aa"
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
