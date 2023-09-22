class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.50.tar.gz"
  sha256 "606520f3f89970cbcfaf6c01d109af12fba6c9fff30222b8fa7211527ba11f6b"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34b3e05a8aa69547089bb61a0fe210482841a2142effe3be065c9023e7760b74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "258020c51a302554234f1dd77ed5befa40a870a7764a1f1e12f5a5d083980bf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1de44e827b52e6f5bf0e00aef41da3c03f6b3bb6c4bf859dca790e5e3e732bc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44d94f37386935a771d701f1bb4d34bf15241d613f3e802ce61196bc909c4338"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdca6e8d073163e3ab999e1fac3b062171b18cd0e78914bf044e1c6691def7bf"
    sha256 cellar: :any_skip_relocation, ventura:        "601f0c93b0b5b3ff56803a4a88746ccbec039fbe3af387243f747c11a15c030d"
    sha256 cellar: :any_skip_relocation, monterey:       "d08de57e060f213d994a6af23c8f222bccfd5370861d3fe67d5d68b035023cec"
    sha256 cellar: :any_skip_relocation, big_sur:        "43133f507e332fd5eacf15511eb4576b19224c747e8bf1e74029bd6e8cd49855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34afc4955b7dba33a3732ed2ef954a9b52c49b9547a28d7be53aaecf320dfeed"
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
