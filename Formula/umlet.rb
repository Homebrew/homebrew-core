class Umlet < Formula
  desc "This UML tool aimed at providing a fast way of creating UML diagrams"
  homepage "https://www.umlet.com/"
  url "https://www.umlet.com/umlet_14_2/umlet-standalone-14.2.zip"
  sha256 "dc09538d04cb899218f3bdfdb5205f60359cff68cb1428d1228c6d91743d8cb9"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    rm Dir["*.{desktop,exe}"]
    libexec.install Dir["*"]

    inreplace "#{libexec}/umlet.sh", " java ", " ${JAVA_HOME}/bin/java "
    inreplace "#{libexec}/umlet.sh", /^programDir=.*$/,
      "programDir=#{libexec}"

    chmod 0755, "#{libexec}/umlet.sh"

    (bin/"umlet-#{version}").write_env_script "#{libexec}/umlet.sh",
      Language::Java.java_home_env("1.6+")
    bin.install_symlink "umlet-#{version}" => "umlet"
  end

  test do
    system "#{bin}/umlet", "-action=convert", "-format=png",
      "-output=#{testpath}/test-output.png",
      "-filename=#{libexec}/palettes/Plots.uxf"
  end
end
