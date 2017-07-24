class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.16.jar"
  sha256 "4f377b42e122f92c3f1f3b4702029cf0642c7d6f3ce872a0dfb1472eac65be44"

  bottle :unneeded

  depends_on :java => "1.7+"

  resource "server" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/tika/tika-server/1.16/tika-server-1.16.jar"
    sha256 "d25c1851b3d448cc025666a6193cc1636ab412ecc5bea40e31431a16fe472fed"
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
