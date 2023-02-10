class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.23.147.tar.gz"
  sha256 "12d0bf092fe7e7c5134fd87a2eb3a6688c4a98f018892e21973861ca90696e38"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bca2ec88fdf470d9756ea57e741bd4f810ff4f3fce6151629d83aa50ba7fafe4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ca39a224c7eb4d1da477fe24fd219c5c7fe45853edeb01357fb398a3512c54b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b37ac9ae86b89ba0ff9e709cf0400c6ebbd39ded29c5b72b7827d50aee8d67a7"
    sha256 cellar: :any_skip_relocation, ventura:        "d0eecf1c865aca5eb94b2d56e7ccad1091093e7386b08e4ea1afc6f8eae73d6e"
    sha256 cellar: :any_skip_relocation, monterey:       "e0931fba524039192f8c72f401d9b7e8e1df5e9ad15d313bef95fc897673fa0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f87af7b6c0234d328d137c0fcd2a78b62a03a056bb6021abe4c6c4102451664b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7a45147e8af4d81a3ea081567dcc29d193656fae2749c59b028084efdd6d75a"
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
