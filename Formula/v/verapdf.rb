class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.217.tar.gz"
  sha256 "ea489cf74819e62c29818191d2c7e093a9a4d376d26f9ebfea699abde369f9e0"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1e44f1f2d0e4b1537e467d0a9cc6fbc35cb649f243fddff7bcdf37c489718e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97ccacb20bb301133505c4104c97c2bed05886641fccc1a16cfa0d4f0734d35c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d520a09f4e77db498e709fd825ef531086938be613d1d0cc88cce7d91f73d17"
    sha256 cellar: :any_skip_relocation, sonoma:         "76f5d7342d088d0ef635bbe89cbf6f780e43df94f685f467b4fff9d1f48a84c2"
    sha256 cellar: :any_skip_relocation, ventura:        "e9ac81decb3f60aa9dd2b3a89a27ace0e024315726053fc1ed3c92d21802fb9d"
    sha256 cellar: :any_skip_relocation, monterey:       "88c83f4792d3e1b4378ee65cb358b0974400475573eee26ee08ae45c787435bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ff32b2ac64159ad33264e4dadde110cc16dafc347e0c8b4d6803438a4cf7da5"
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
