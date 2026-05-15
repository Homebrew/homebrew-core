class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "5efc41110eba2f5fb9ff13511fcf058cbecd9ee1c8e9f6fe66b8806aaac32c37"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468]\.\d+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df7fd4ab31e82d978692ab44aa1a97fed36a0fd264224bc336321a52ec076134"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecf7bf4a37e1449dc313f2918476a2760270e0ee71d6e8f32be0ff2667b1aa80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9ebea276b621b8f0640506c03acf6fff126cb89a2011e0c5cf87a710d7fd24e"
    sha256 cellar: :any_skip_relocation, sonoma:        "61b3a7dcfa8cae285fc0adb56c66eb634b2ad170dd263bcd57758a3d90310353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dc10c3493f038ec1da7b835b546ab2536b065d8230e92de42ef46cdac89557d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1119ddba3e432e6d7538fb0df24305dfcbfd8c97826506b711f212d86c516ce2"
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
    with_env(VERAPDF: bin/"verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end
