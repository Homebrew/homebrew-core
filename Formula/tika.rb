class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.12.jar"
  sha256 "8c65549f8d307bd887326813009f9c29e56c1e924ddaa30fb90f36e8aada3be8"

  bottle :unneeded

  depends_on :java => "1.7+"

  resource "server" do
    url "https://repo1.maven.org/maven2/org/apache/tika/tika-server/1.12/tika-server-1.12.jar"
    sha256 "df6566dd8f77bda654fa9c590c0f1ddcc8cfdb18f17cf0c5223ae5ab2792f9f1"
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
