class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.197.tar.gz"
  sha256 "42eb3be5ff6c04625479ff34d55dff07670997f3611a30f5288cd6471ca0bdae"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "292da07449c02f6c035566b13ea1c816b2393d96e5cd8f8a122a9c83e840f478"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e421a481f32d77c2b2015a9587d30544ce8c2c28826faf4af66a427c4d1883b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14ca165f2dd30811624f1115e74be377d4ea137d354edc2846e29a155d49d27a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fb3db4272ebc4a83762d64db0e8e9557002907745672c173bbe937f91ba87d7"
    sha256 cellar: :any_skip_relocation, ventura:        "b987539194c8bb798af567e00c6f364f2ad690292d5bbe41fda699aa27a5b6c5"
    sha256 cellar: :any_skip_relocation, monterey:       "5c873f21b8b63d6ac2d42dafdac4ff1e2bd89cc1ec972a51c56602329c902b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cc7a89d2b0eb0a6af91870665e314245b28c5954a66e6543c33bf93e4f93772"
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
