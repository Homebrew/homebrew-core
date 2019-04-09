class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.20.jar"
  sha256 "0101e805555efd65bf1878276a8790fa51e9c7e89d979daa137b9fc8bf8cbd58"

  bottle :unneeded

  depends_on :java => "1.7+"

  resource "server" do
    url "https://www.apache.org/dyn/closer.cgi?path=tika/tika-server-1.20.jar"
    sha256 "d80ad0f5f3b8d1b58a9ff9c43c6ad7c1c736ef0d9c63ee7e8d83e948aff2d274"
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
