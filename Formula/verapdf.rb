class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.234.tar.gz"
  sha256 "1b7293979a316c7aeeb0e00528266755adcaf2b1ca14d1f8ecde8233c560ad28"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77af7a0f33e67ede7453bd5973ac083ed8e6be5233daf5d99bc591b8d8cd1ce8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d57861f065242f2312693cdb3d009478ff67a22e8244720ec65dec1bd1a4df8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7318c7b8965eb757f4d2688edbb4c7913d3f86429e7ab37dc07a5812c65c841"
    sha256 cellar: :any_skip_relocation, ventura:        "ea597f25093deb9f2107127169c0a2b5f422d2e3d5df1c2fc4dbf3fdd75c9c58"
    sha256 cellar: :any_skip_relocation, monterey:       "bf6e1a7fc4ebd882a253d68dddfc0704111612ea52a342f1f6268b077d00fef3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ba23925aebb5c3870f68e34e22518f2e179563303926eff8c6bb3c7d15c0c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee771f497a76c79f61353bdb9541a9e0114e89ea08bc3806f91cf68b264a6b36"
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
