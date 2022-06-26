class Umlet < Formula
  desc "This UML tool aimed at providing a fast way of creating UML diagrams"
  homepage "https://www.umlet.com/"
  url "https://www.umlet.com/umlet_15_0/umlet-standalone-15.0.0.zip"
  sha256 "81dbe1a981b2ac5b90861ae4176eb05dbdd340b4422e6e7dfee4b14cf9877401"
  license "GPL-3.0-only"

  livecheck do
    url "https://www.umlet.com/changes.htm"
    regex(/href=.*?umlet-standalone[._-]v?(\d+(?:\.\d+)+)\.(t|zip)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eeeb59f174b8e131ffeca89d11086ba325d63751614a7fa6b28991164da42fd9"
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
