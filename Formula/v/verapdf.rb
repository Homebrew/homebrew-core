class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.73.tar.gz"
  sha256 "61de8c7b82fd279e2af429ec1ce0d13198af51474624682f8c3129f797e094fb"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29e9225594babe7ffcd6da9578b7e0f1d5624f72b89b8c403a82009c7757a0ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61858e6689c3681294d557dab22a5f94bd6ab4549e4be85b8928be68a3591825"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a242a38af440dc3a5c91520fe35e03d9e9cfecd3e0e969de8bd8b8b2ec6de3a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "54b67455637428323d561ae68adf7b3cf95d281e6cb40267a2a589867789307a"
    sha256 cellar: :any_skip_relocation, ventura:        "c631164189bfa18c5988ccb3cbfc1f7fa6d00d065d49a339b9d5da56ab1e188a"
    sha256 cellar: :any_skip_relocation, monterey:       "13a0c2bf980a5dee2fef5b263084ef9b54a3d8f360015456f1cb9ad26f0e00aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0faa9e095504a8f662063fb5d7ceefa3eacf4a05e7a3d934077e4fc2e5bed7b1"
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
