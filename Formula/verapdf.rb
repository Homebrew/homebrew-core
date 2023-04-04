class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.156.tar.gz"
  sha256 "c7a612fa1d08c45003cdf3e98fa810346855ebb908183a3ba5e4df105a7f0b5a"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "006363f64f877876b6cdfc7763e5d5191cf4078d6b9fb31a3fc8606619191656"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cbfd2fe05694140d0ae27a7c2d6fa2ab83e5cbc8759e81137c5a6352e40536b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b348c155a5f972d7837b8e02c0a39d3246e6a3d647b91a76dfb427aa3e481e9"
    sha256 cellar: :any_skip_relocation, ventura:        "6cae44e8d6f6fc12d17ce1bf04d92dfebd5a73dff83bdaf9ef9628e77841fb5b"
    sha256 cellar: :any_skip_relocation, monterey:       "d96157af24a892d295eb449c4e29b99e832368beef3b88bf45d3d9911b33d261"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b066a70cf4e7283594fa846ec85da06ee3ba12b7038a07f86d3b8db4e35ccaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7a909734b081aca4c5255920b7a3d13ee452abbe2a6d386ca8f050138e3a334"
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
