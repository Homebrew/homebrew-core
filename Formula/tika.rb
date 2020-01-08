class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.22.jar"
  sha256 "d7219709abc547136fa5fca17632a85fe1cd36dc08cb4031957e3c9a836543e2"

  bottle :unneeded

  depends_on :java => "1.7+"

  resource "server" do
    url "https://www.apache.org/dyn/closer.cgi?path=tika/tika-server-1.22.jar"
    sha256 "9913c69e8481edd848f27a7fd912300acd6f0b29044f43fe705a959119e2f44b"
  end

  def install
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-#{version}.jar", "tika"

    libexec.install resource("server")
    bin.write_jar_script libexec/"tika-server-#{version}.jar", "tika-rest-server"
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_equal "application/pdf\n", shell_output("#{bin}/tika --detect #{pdf}")
  end
end
