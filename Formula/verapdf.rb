class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.146.tar.gz"
  sha256 "fa89e62c65bb2f8344f0f2bbb8ac89d5738a9b9c109e9b26df2d0cbecf33a970"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adca86226947ca61c66afe1f3c0e442231ac676297424566bcd60527ce301c6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6f32e7c19c42dd009c40a0d39f216b5643255eebccea309f7b409cde6e8e5d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d52b8f2ac63f5d94da8f0747607cae286f80b6c5eb901f72492415771baf2620"
    sha256 cellar: :any_skip_relocation, ventura:        "9df334e81a37b3cd30292cb71fc46019733897f749c300d8fd000b2a6ea2e78a"
    sha256 cellar: :any_skip_relocation, monterey:       "1a16cce637b8542c788f300adab317bcd14084559d832baf6d6cce0f6e2ddd93"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa0e95f23a285f81992412b4f51eb2d88e6601c3e1b863bce19b99432c4a0fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fc7ac930850c18ec7a99ac8ae3822ba868f9230f45c90258ba9ea001526299c"
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
