class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.26.2.tar.gz"
  sha256 "f5577313bcbc5b5c6a282c1b61226d0862f6fa68b1e87b71ac3fe529fffa646d"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468]\.\d+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "aaa936d8b40963c6729c9924b137b8a32903deb839d4e70349dbc6095ead3e86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4d90f5fed9950389a5fccbee6db56063c5d9ff6ceded3a503f021ac9c5eb152"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d5cd459ba8fc3787bb60e5b5c500d246f328ed6b950b2f352f9303875bdbf1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b60f29cb959ba7fd1cebe6a0d5577ac207d9bcdf56fc693c445ab75b6efde30"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f7009c41899fe4ec4c94357c1301b322f882a292c92624f64e6c58afb5b3d28"
    sha256 cellar: :any_skip_relocation, ventura:        "47d2f656cc9c6145b83d24c0b7973aabe9aa33ae7108db0baad5072ae6fbd185"
    sha256 cellar: :any_skip_relocation, monterey:       "28609f0acc19cdc6fbcb88c5883c1a0aa530e7646071c46a7ceceb28093a7c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec2e25b862d22d7241e7d1d668ce9e8849d0402505bddc1a82d751b46dc6aa40"
  end

  depends_on "maven" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix
    system "mvn", "clean", "install", "-DskipTests"

    installer_file = Pathname.glob("installer/target/verapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec/"verapdf", libexec/"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env("21")
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: bin/"verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end
