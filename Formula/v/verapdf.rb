class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.224.tar.gz"
  sha256 "f1ecb896f3b7692aa17ab64cd4df2ea511d4f1ac5b461eba86d55e42a17024ad"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "caacaad70b8dc4cf4e3a15351e8fed084cf0cef223130e3ec20d74ebdc2c6689"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f1079bd306ea078379a75507dce46f98ec62302c1b23cc8e3b0f6bf43bfc779"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da9d365865721b3faba89783a585d642f56e673ab1395510351b2e3d1e0d1812"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9a63bec2a79b03198522f79ef7c0241a7af9430aad47f2f21f26b7a386719db"
    sha256 cellar: :any_skip_relocation, ventura:        "3e2d0fcbf99c1b53c3a390178f4c3570df1910561b17c7e30aac760c8db3df75"
    sha256 cellar: :any_skip_relocation, monterey:       "2233f7e29997010d60a280394d52a8824933293621a986096dce2ad2956e5851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d02bdb2182528856eafce96ca08b96598e6936ed148c1bd9e95b71209513f182"
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
