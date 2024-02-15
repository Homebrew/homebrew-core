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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afa3cdbf98fd049f993dd699b82c82c424208d4da023596167bf2c8834ffc150"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c743dd742998600b48ea88abf81fe000c346f72c3a0fc3782fb67e1b5365b1f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "214d982475706db6a5692f07a480fd18045172acfd19c23a4b72539ae1861e4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "bac4a739ff6e36703528c226ba77f673f8c77023f8f6b77a605768915b084723"
    sha256 cellar: :any_skip_relocation, ventura:        "b4d7a17f745a8cfc3d31a490665d0f46ff9fdb95326991795ad23b290015c944"
    sha256 cellar: :any_skip_relocation, monterey:       "06fb8a045bcc3608124d42d3e7b9a1fbd5b3e22c922c8cba265e6f80b523963e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a605e419480a59244c36d71e2db3974a82b3574639f3e0597a885ffee271332"
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
