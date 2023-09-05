class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.42.tar.gz"
  sha256 "f5d77854a2d5092e19a36981b9f03065c3d0ad38c42ce0d16f9b1676219cd9c8"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e75252f1448868e7e6bcda7afaf20b5168824ed01000e0ee705518f90eb971d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8d51d12606105aaf59305a6aea8a444d3bb7c0b9d3d518369bc58c429dec836"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d72f50333048209a77dfc3c1d37ada689da3e894ca1d23f6a5a197048f806620"
    sha256 cellar: :any_skip_relocation, ventura:        "00ecc4084657e7876b9e63776f79f7164cd5c6ccded8e857556c06076f46d14c"
    sha256 cellar: :any_skip_relocation, monterey:       "62e9ef9bbb37affc79ea37ff54c4c5c3e27b0e4aec28b422748964db728569a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "541ae5c521e4375d473f3b9bde9c13df1ce42930e2106b0ca44dad082bc519b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d77a9cd3350ea2744ebd3cbe67bf220bfdc28849e78e23ac4af701e51b2c1d1"
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
