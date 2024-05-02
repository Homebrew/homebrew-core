class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.252.tar.gz"
  sha256 "bd3891af2dc5c924060387ab0db9ba6faacd0c023de66ff6b492da01d72d3e89"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468]\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25ffa454b28be6b00ead179d49a8f0da5e73a73505ef566507e06b1643f62774"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fef055f7d2fb0133ef253bd87f31be5d597121a0bc7bfb5d81cb63be3d0dad85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "518cd39ef6c45b8d360d7b6fed6aae8d529ab6065bf02c73e4f99cc4bfc20921"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4b691844b76f5bbd5754e03ce33496b028a13d811085780ce67309541b49fee"
    sha256 cellar: :any_skip_relocation, ventura:        "84eebea6ae0d5733814ae03d7275c82b65ab2363b86df2e133fb29d69df77da8"
    sha256 cellar: :any_skip_relocation, monterey:       "60b8e1dd5f3d13c67ba8475f723ae570353601cd6a78a79e366b9e38866ba115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79a2a9ba6760ecb65e9ea3f0b555eef8b94193c5261fb93be99ef5e4a8d08863"
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
