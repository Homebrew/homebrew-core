class Umlet < Formula
  desc "This UML tool aimed at providing a fast way of creating UML diagrams"
  homepage "https://www.umlet.com/"
  url "https://www.umlet.com/download/umlet_15_1/umlet-standalone-15.1.zip"
  sha256 "33aa1559b3a63c14f2812f9316463d3d6b9c15f60b0f7decb8d52e5a914b308a"
  license "GPL-3.0-only"

  livecheck do
    url "https://www.umlet.com/changes.htm"
    regex(/href=.*?umlet-standalone[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "81e9e4e1e8f71f11e7ddc0468109c03b5fc37353620c24c34fca14eace0b1373"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.{desktop,exe}"]
    libexec.install Dir["*"]

    inreplace "#{libexec}/umlet.sh", /^# export UMLET_HOME=.*$/,
      "export UMLET_HOME=#{libexec}"

    chmod 0755, "#{libexec}/umlet.sh"

    (bin/"umlet-#{version}").write_env_script "#{libexec}/umlet.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
    bin.install_symlink "umlet-#{version}" => "umlet"
  end

  test do
    system bin/"umlet", "-action=convert", "-format=png",
      "-output=#{testpath}/test-output.png",
      "-filename=#{libexec}/palettes/Plots.uxf"
  end
end
