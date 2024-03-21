class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.220.tar.gz"
  sha256 "be3e11995b273dae4bc50bd1ebd68971a53749f88bc0707bd29b83e36cbdc326"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31e535a926c86805c764e20b966e519ddc79175f9f76fc2397a49cf7013010e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30d791d71e56d93fb716289d0cd86e1f2a56807e9b70dcc46db52a73e938f8e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f7fc0b2104497a4b79aeb1b4be8552c801e138301dcdc5400d58248260bc136"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6c4bd5748742a2129dc689bb4778e7bbb520f7dfb8992dc791f91501d8fb1d0"
    sha256 cellar: :any_skip_relocation, ventura:        "f3cce0f6d7ef411479ae2a7f7cc239cb65665d94a7505508df7d7ba75873c667"
    sha256 cellar: :any_skip_relocation, monterey:       "c99d8ff2e041f00a9ac0a7cc5b68cbddfbe165738ea3d418c228e89aa9e20477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f43f31f15f83db5fb56a16869dbcebc44b9466aa3b91c3188c747c31de1b36d"
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
