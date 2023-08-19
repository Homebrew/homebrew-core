class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.35.tar.gz"
  sha256 "5f854c7376d9d7c91e2577058b4ccc487dfb370e25b5c5d3bcd856cde4f1b9dc"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fae84a0ce6d2f767aa35d97bd1f9f0fea02bbddbb641431a67584c376314e748"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fee82e70cb308ad279b137bf32b657ca951f6faf19868b7944af1c11452b0e5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d056e078e7a0ff577f8a82108777e2b903830b2250f4a44ae5b3bcb3cf4d825"
    sha256 cellar: :any_skip_relocation, ventura:        "8cf0441096c0e1ae878d3671a547c5133cffdc57cabd79fccab328d4d0c92a4a"
    sha256 cellar: :any_skip_relocation, monterey:       "bb1c85232fe14f27d808ecd6a8f619452c0493fdc30c2174102d199a5bb7c94a"
    sha256 cellar: :any_skip_relocation, big_sur:        "33be5a5f29c3e41a3dcbf53842c346f02aca287bc5e002206b1369125de223fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c6fc053314dc99c91cbea13093663c8366f30f390c06eb45d78a1f1509dbbe5"
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
