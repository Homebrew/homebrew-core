class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.23.tar.gz"
  sha256 "d5bcdb9113079983c01677e5ea75d57b5f404fd6d2b82bddd8ba95bbd7a3f852"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "890e3b0cc1fa305f135f79f44ab1cdeee6b364315aad44607d67ad698cb39577"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7439827e2b690cb1529c4756e4dc0025ef142bbf709c281c99c0f807a95dc110"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c280a1d9f920de2cb00ea62a5e2d744e6328dedd54a73521153870d40e6c4a4b"
    sha256 cellar: :any_skip_relocation, ventura:        "a128a3eb562d01ed9aba3ea8633bbd1d5e537184877fe8d1fe434666b48f62cb"
    sha256 cellar: :any_skip_relocation, monterey:       "49d011c7bbbb0bdf5c902884c5d0d821616c75ad95e8c5e6a71d0ca1e8aad029"
    sha256 cellar: :any_skip_relocation, big_sur:        "e00649c31dbbbafe3cc8e4dc50d5e31ead4fa0dbfdbbc4c247d08b967d3adc4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c96a4bc57c40c08f01eec5c41908955dfe506c881fb39768b2b2c9e8d30882c8"
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
