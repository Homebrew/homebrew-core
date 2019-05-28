class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.21.jar"
  sha256 "0d5f8174942450ab0eaf9f07b286b8ac2c3f3734e69e5fb72fd5be5be8b4e433"

  bottle :unneeded

  depends_on :java => "1.7+"

  resource "server" do
    url "https://www.apache.org/dyn/closer.cgi?path=tika/tika-server-1.21.jar"
    sha256 "27b2d50470f690c20fab960aa1927973a0db40972e2899f60113e7d2631d349f"
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
