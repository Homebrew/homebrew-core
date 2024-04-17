class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.246.tar.gz"
  sha256 "c463a0cfb188ce3188cc65703e6f97c9f8aaab714402ea23ec9775ac6bb6818a"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e8e01f88051186872d547a8998bc59ab6e6ee67f0d834cb45ee76cef805c473"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ea8ebaccac53e20c0297a188ee0f3c612d1edcfbf4ea24207bff13d5c2f293d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a9bfcaa82ef631878af817487b0136da0dda8a976e1c37a2505a556f1565574"
    sha256 cellar: :any_skip_relocation, sonoma:         "af81d20da188d508cfc2505c7dc7686519165f09687eb00c5897a83893e98db8"
    sha256 cellar: :any_skip_relocation, ventura:        "9a79863d3660de63fd7b8e745fa8de3e32c114930bc3743eaee5ec17b09e17ae"
    sha256 cellar: :any_skip_relocation, monterey:       "491580b67c0fc1b3da8f059c5c205c2e93f3f8389418b052668d2cc80ac599ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2374d6971edabe605a3f2ce612dc0eae03d71514d3e4451b6dd24a7b0132fdd1"
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
