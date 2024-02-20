class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.205.tar.gz"
  sha256 "63b1daed23034b6ccc5af93b471d733c3e7c63d9d1ab1f1a07fefb09acdf9f65"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f89d7bc5eb028c83b45fca6507bf2c47dfd916d7fd7d8b2f6a9534bbd56aa8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2970844efb72c046a8c2412fbf87125b5b4a606b4fd18f17f90bdd3be8c7de2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4411b1cf73226b897a909c565677ce4b71ebe15abe33897bcd1e2b6000414368"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f69ea959d0e72e63abb73cbad5e5f4b8941819e3efda76124d02dbfb93d3cbe"
    sha256 cellar: :any_skip_relocation, ventura:        "faa3c3a6abe5fbffa834a3c19d98582eae28f4f0d526dc81f70aedfd6a11d6d5"
    sha256 cellar: :any_skip_relocation, monterey:       "cb5cafea4b89e01dfe4062fc006160f76b67ed2dfe11daba582c27589748d02b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd89a8eec64d9cb66af5d5fe894eb394a1914a3d844550288f88fee6434046a4"
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
