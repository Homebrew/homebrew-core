class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.229.tar.gz"
  sha256 "52aeac3bfd238d0f468be3c340ddddb34dbfa6fba112b527b4bc1404d734873d"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29f8f0686d82ebea84a8297d517fa525d1d1c3c536c56f2fb6de64c9d6020f03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d497f00fd87787c00bb206a8a2963a7174f04edcf916186a25b7bd1b04520bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5a01debefa644ba1f31313486399ac5c16d993078088ecec8b14f4aeb4f16c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6ce2afe26d5d91fce96d5818cd102c5720a21aa5f62ae0d230a7f031ea8c20f"
    sha256 cellar: :any_skip_relocation, ventura:        "dcb602855aae0524ed664ee94ee524c84caed28e9b88eb1c3089b996d05f2ce0"
    sha256 cellar: :any_skip_relocation, monterey:       "b5d6ec33a04d122b19f24cb5dee1a4918671c94f67a0007c7df56639ff5738ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a73bea7e96873b89761f6a4daf3f630e988698579678ec7d2f58a90ab1e4e39"
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
