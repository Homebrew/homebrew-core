class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.151.tar.gz"
  sha256 "b26008ea623ab40cc576e0f717093b8214410c73695cbbe4115a8e736ac4001e"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36a5d35233b37df5126153971ae4b6ed500c8669b3c3e9cd110ff0b756ccd5b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6fa96e27dfc39b6dc9684038da37d38d9307a6b6de8c204b65ac919adf4a089"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69c313a82de4a4ab6900ab2f8e45e148a712cf0894f864ee17d4b48f12f92aa4"
    sha256 cellar: :any_skip_relocation, ventura:        "a9bba51838767b71aabcb8e44cc9793c2300d9f786bf28dc09f2b7b9df89c05f"
    sha256 cellar: :any_skip_relocation, monterey:       "0709e2b9a9d241c1cb5849e0195ef6a86ad1e2b9fa4fbb1d855a51c170ac0dc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "740bcf0f17a7b3ad5eca2543c5cfb7faf4f1962e4621ee2d43ce2423557d7538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8306b3cca4b2c3ff51a8558ec006521416b5475899b82f08466dd3c155a1072c"
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
