class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.198.tar.gz"
  sha256 "5a37c9c8110ce388a1f1010980de46d62fa76501ea441167d35f5abc26d12503"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "128b0b4859c9053cf0bc589feb8e17ec6e21c8a133d3055322a9306763ccfe89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "575b447cc24f7cabd98314b38390786cf0240c96c6c0513e98345e8bddefb1be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce2e53c3009f06179764b46799c162f98c80b55269e969bc5fe4d636ed5a92b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb8ab8cfefcc28db5d32add2bcb655a660a89ce83e7217b5e3aa2f10b61e0b2f"
    sha256 cellar: :any_skip_relocation, ventura:        "5af3386dca7660546c0669c152401a23b19f303461238e7bdd29e5e8581f8921"
    sha256 cellar: :any_skip_relocation, monterey:       "c0b0a70e229cd8d3c4070ec448aa6c47f2f80364683eb0b5a0c4e40e7e3cf913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7248ab55b7a401e989ef2fe3304a8f7b815b1eadb7406497ae51e5730401c65"
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
