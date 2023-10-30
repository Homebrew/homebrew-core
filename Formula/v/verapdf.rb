class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.92.tar.gz"
  sha256 "9da1eae89f37134d7b6e41666e53d577f65c672817f42b3e23672ba5ef1270f0"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e07908ff9cf3b9947ad66cde9e603a8c38797d69d55b399a4b2291b1c01cbb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "941ddc82f71402ecf8f1916c95208171db88e5ce7a849dd0a1e15ea55da64afd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a70a7fca862292e902d6fd3011f660f4f960667cb2b28822ebd714efa5c0753"
    sha256 cellar: :any_skip_relocation, sonoma:         "b49bc23428b74c3469a5b9f19851f5ede8d4cbb7589ab718418f0ccdec2adac4"
    sha256 cellar: :any_skip_relocation, ventura:        "61bd1464768e9516617bf7bfc0975500ef0eb255f5fc489292f4312909d2447e"
    sha256 cellar: :any_skip_relocation, monterey:       "1a187c495f59063bf4089b295a68a3519a5ae2048c34e5422d93c8349650095c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db8ec44970d1fac26e204ecb9a5f8ae51d96c222aa0a600b54ed2c06cd1633c2"
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
