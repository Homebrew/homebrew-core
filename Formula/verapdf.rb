class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.5.tar.gz"
  sha256 "7503689af40e47cecd45e504f78452d92326a31701b969b663eb12c0027c9db0"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3116e9179a6ee3cc9a4e23fea0dbece0e736fe49c0784e4970abd20963ff1e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cca30d3baaa1669f84e485fad29fa439354f671bba024095853ec7e463b6662a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3fab25254514a3732ad415f26b2671ded1bcd90bb8a8b64377220e10a49e224"
    sha256 cellar: :any_skip_relocation, ventura:        "b57b28f1d20862559e5534ec2c350c852aad0b4a5f25d6c29391f0196d84757d"
    sha256 cellar: :any_skip_relocation, monterey:       "a8ce4186a699a0381125e99f1cd8b290db991941a5fecd5e1c83a5235315b968"
    sha256 cellar: :any_skip_relocation, big_sur:        "d28f5aec45d6d462bc1f2d0aa519716b5315e680dd646fcb160f7606e0b0d270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e4379ee379e3d774f405a9d4c5049f19f8c96793055acf383c1e578d29dfa30"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  # fix exit code for parse error, remove when merged and released
  patch do
    url "https://github.com/veraPDF/veraPDF-apps/commit/6cc00fca6b183160b482f7aa1e9e1e90fdec54e9.patch?full_index=1"
    sha256 "67bbe4873b0ae190c97bd29a3fad5d3413b872c4526c480e96272c71a3c15e43"
  end

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
