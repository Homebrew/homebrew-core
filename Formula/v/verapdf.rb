class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.226.tar.gz"
  sha256 "1ab2ccf234a93c15bcd140c5d1d70a004e624897390725168eb9ff3819f118cf"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85d85b76131af374b5a0a2284b92ebe30cd6015266e019f0c1a25bb315949845"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "136e4215bf453e7854fd60d679f8682f7f28e3acf94d20628ca197e9a4bde3de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12c06c0454ae151c62601d33917f9eeb28684cc9473c9f871402922a5f6df78b"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e93f299ddac208944c91166571dc54cfe7a1a9cc3d1c1c8f38dba8033957f9a"
    sha256 cellar: :any_skip_relocation, ventura:        "d1ff0605782b9c71c03e4e4b4794efd5f1e790f3e34721f139e3cbdd4e554756"
    sha256 cellar: :any_skip_relocation, monterey:       "433fe5e69fbd6ecb3633b8b3ae1479123af3be59d2b2ecce5fe2c2f4e881db7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7352c8ad5a861e626de43a65d01191a3e7c1bf692978d3a3ea5ba01accb8349"
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
