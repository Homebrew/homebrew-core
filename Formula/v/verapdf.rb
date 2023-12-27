class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.164.tar.gz"
  sha256 "43805c8585b3230a7c17ed405912a922997249c72ab0b367a3b6414b7932c58f"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0aeb731ec3efe973735a62f38dba597d9d26d17f619291af04de31baa9cc167"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69be69cbdf7d2e94bfd0d686871796356f3fdf3f0bf7521fd00088aba1261db1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "161e34394d75590b47a671f2ca770b729537bad86d334e596d91b1e0f6633166"
    sha256 cellar: :any_skip_relocation, sonoma:         "2847686886c334ae6196936da12683ef7354ed8e61c85365499a68ac23674b5c"
    sha256 cellar: :any_skip_relocation, ventura:        "d74263921f4432cc783ca065f33cf273d6d4327cccf86cce8db5b23f296b76b0"
    sha256 cellar: :any_skip_relocation, monterey:       "b1b33ed39e4158e3c2bcffb12b60b91cdab07d8f801619896f102417c5ca2015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c54117ec3d417ae83754f329a12e31e54b6889c7a89a5bfaf0d878720bb06a94"
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
