class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.24.3.tar.gz"
  sha256 "f397dbd6af24ebc5905757d86f870982c8c2f17ffaab78a90fb8a0b6a976b2e5"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468]\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a87f8867f88e91ba6d733fbd23c60c783b44c5b79e74389f1e2af8d5fbe6fd46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ece1650f68c0212401c0a12d4a7dee56c4e306d76e9d292bbb516b935dd2dac6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3682995eb3a4f6b3ec9a7e99222677fb2b8f0dc5241d2096d6818dc6669efc4"
    sha256 cellar: :any_skip_relocation, sonoma:         "511c1ed7a220f3a439a3df9ddca9afbf6a12759913c5743c9c428815a986cd41"
    sha256 cellar: :any_skip_relocation, ventura:        "6ae8d59a8987f2e480c7166dbfa3823a6bcd4f1f2ae7ff8e9de3dc5d5186e0e8"
    sha256 cellar: :any_skip_relocation, monterey:       "b974c7e84ec2c793d86f2e3ef5959ae62ee02a11e739f99357fbb0fa93e2b74b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2a65a1f33662a61858b244e02f80b8c6cdefa01cfbd63d51517117f5d3fa9f1"
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
