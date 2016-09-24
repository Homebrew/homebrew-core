class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.13.jar"
  sha256 "e340c3fee155b93eb4033feb2302264fff3772c80a5843a047876c44eff23df7"

  bottle :unneeded

  depends_on :java => "1.7+"

  resource "server" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/tika/tika-server/1.13/tika-server-1.13.jar"
    sha256 "97bcecd72271c75ecd715619e4f91bcaae84f0e06a1e9c4f3ba48d90be9912df"
  end

  def install
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-#{version}.jar", "tika"

    libexec.install resource("server")
    bin.write_jar_script libexec/"tika-server-#{version}.jar", "tika-rest-server"
  end

  def caveats; <<-EOS.undent
    To run Tika:
      tika

    To run Tika's REST server:
      tika-rest-server

    See the Tika homepage for more documentation:
      brew home tika
    EOS
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_equal "application/pdf\n", shell_output("#{bin}/tika --detect #{pdf}")
  end
end
