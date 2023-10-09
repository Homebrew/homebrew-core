class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.67.tar.gz"
  sha256 "a431cdcad8e4994efc5c80da8223ec4a111b1a99da80dc6c956101188138321c"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac47b13652bf90fbefa4ec798029d57bd1d71794aa44a11c08e5b0757d30f73b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb24c55e4786c7eb816a7a3bc77c88c1a44dc8a6525566d133db40b0fba187e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff8efee7be0b4e30e60398caec9098ae30b603b0b2e0544325db7fd6676d48f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "02541ef95293f091e464b99d67e1dd248adee20361cf66648d8db07c130980fa"
    sha256 cellar: :any_skip_relocation, ventura:        "d1e51f91fa48c5824af979ec14245764b905f2972e30e3d433a61ac7ac2b1938"
    sha256 cellar: :any_skip_relocation, monterey:       "6770745f92b3b9eb06e5b46ad6bc9fd215275179cbcdb8a9aec2e292d5dde2f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df578efa052fabe3a466fed14e8b1c71073d2b303762c52e0eb8363e47aceeb3"
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
