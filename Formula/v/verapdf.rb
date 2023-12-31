class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.166.tar.gz"
  sha256 "df696ebe34c6fdc266401cc001dcbcbe06907c597ede85a51f2f06a71ff56607"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c648f506da5a98223ec235edf7eaf96bbcbd627019e1cf998cc9dc62414c2e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc36ce542b4498ccc03f6e2e677c89b9d1ba6368ba5a0c57b4d6b026cc859fdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f55132a436cfb0c3c314d1361e8efe3ae60165e3b02f2dfa4474637638b32b2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc5d0cdbcb7adcebae5921523e976b48204cee8d4abc2e716ddd532e9fd829cb"
    sha256 cellar: :any_skip_relocation, ventura:        "3b70ebfa041765abafca91d89a19db6871c6782046ed23729fbaf15828873394"
    sha256 cellar: :any_skip_relocation, monterey:       "34bd5a1bb838bfef45a2dd728c4635a474a2ca8621b2ab70dde669c6fcb6ca6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0413e448c601e2e1659dbb413c26c2e1931c37df24ca177b601f633436f8ba24"
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
