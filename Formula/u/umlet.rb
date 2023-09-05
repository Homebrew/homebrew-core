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

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c1f2fe34db9d230b2b4412488efa3ec266d994bd72f9df8871b320321862ce7"
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
    system "#{bin}/umlet", "-action=convert", "-format=png",
      "-output=#{testpath}/test-output.png",
      "-filename=#{libexec}/palettes/Plots.uxf"
  end
end
