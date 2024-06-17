class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-10/v10.1.24/bin/apache-tomcat-10.1.24.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.24/bin/apache-tomcat-10.1.24.tar.gz"
  sha256 "216db5c726a6857e2a698ba5f9406fa862d037733f98ab2338feb3fc511c3068"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ead5f045c078c481ed7647d3f248844a10405caf4640a33f5d222d61a3dfe1ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edaea8117ae38e3e66f8babe6fcd35f72b0292791ca9331b710da4f377f4f5da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48161ff834e31968fe683eaee2e420e78499459eedffe81903a873d7078c6002"
    sha256 cellar: :any_skip_relocation, sonoma:         "603c35d2756093c7687b99515a01dc08750a89f5bf0adf2566d9ccb22c716728"
    sha256 cellar: :any_skip_relocation, ventura:        "85c60900073a9a81e41b7d3993e0f75c5453288680e0c66b0c7ed449840e073a"
    sha256 cellar: :any_skip_relocation, monterey:       "526befd6ea1f44e740a651b6f598e385b242a82eb430b7b21297853805693fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d832e3476d6e0b4207da4453c511519f578d6998c6154fda99e76f4031b4278a"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]

    pkgetc.install Dir["conf/*"]
    (buildpath/"conf").rmdir
    libexec.install_symlink pkgetc => "conf"

    libexec.install Dir["*"]
    (bin/"catalina").write_env_script "#{libexec}/bin/catalina.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  def caveats
    <<~EOS
      Configuration files: #{pkgetc}
    EOS
  end

  service do
    run [opt_bin/"catalina", "run"]
    keep_alive true
  end

  test do
    ENV["CATALINA_BASE"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{libexec}/logs/*"]

    pid = fork do
      exec bin/"catalina", "start"
    end
    sleep 3
    begin
      system bin/"catalina", "stop"
    ensure
      Process.wait pid
    end
    assert_predicate testpath/"logs/catalina.out", :exist?
  end
end
