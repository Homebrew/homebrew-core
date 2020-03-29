class Umlet < Formula
  desc "This UML tool aimed at providing a fast way of creating UML diagrams"
  homepage "https://www.umlet.com/"
  url "https://www.umlet.com/umlet_14_3/umlet-standalone-14.3.0.zip"
  sha256 "f4b064ed57ac0640daa31f5d59649a95596fc9290e503734ec4974a9bbecde49"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm Dir["*.{desktop,exe}"]
    libexec.install Dir["*"]

    inreplace "#{libexec}/umlet.sh", /^# export UMLET_HOME=.*$/,
      "export UMLET_HOME=#{libexec}"

    chmod 0755, "#{libexec}/umlet.sh"

    (bin/"umlet-#{version}").write_env_script "#{libexec}/umlet.sh", :JAVA_HOME => Formula["openjdk"].opt_prefix
    bin.install_symlink "umlet-#{version}" => "umlet"
  end

  test do
    system "#{bin}/umlet", "-action=convert", "-format=png",
      "-output=#{testpath}/test-output.png",
      "-filename=#{libexec}/palettes/Plots.uxf"
  end
end
