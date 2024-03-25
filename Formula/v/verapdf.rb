class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.227.tar.gz"
  sha256 "b40328aa7681d5a2ebad1d5bbf940503f981f6de0cd3e67148898d8ecafadf79"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e6e9690febf2ef62c33e312480ad758f8d3cd154b44be32d56e4242066051d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4c8568b05c070bfe9a4a24fa80de8c1249008738f6713a3abf19059b98b6f89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bddc12068f1f31374739e2f29682050b237aaee4d245f178b164ca41a36746f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "17b1920eaebc9d112223271bca917f213995f8465106b211cce66896c8ca5255"
    sha256 cellar: :any_skip_relocation, ventura:        "c0836417fae8c05ee65b04a611fb3e0fa8524cc6f4fa8bf2f530fa5b5cd41269"
    sha256 cellar: :any_skip_relocation, monterey:       "58fb0c16d99cfd54905c37abea33424f32b871db37236514d422057784b6b95b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "794eb78dd8869dba4631ad48716fc5304b156e94efbff406ba485fd7adb3ee2d"
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
