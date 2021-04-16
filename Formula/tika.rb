class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/tika-app-1.26.jar"
  mirror "https://archive.apache.org/dist/tika/tika-app-1.26.jar"
  sha256 "6ed7332f02e8d80cebafb59907e6d370d9db3e9a81d547e4fc0d071d2cf0dc26"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk"

  resource "server" do
    url "https://downloads.apache.org/tika/tika-server-1.26.jar"
    sha256 "18b5ec5b8a7f80a3ce253cf93c5ea5f031a3c17bc83e88ab0d29a516e8e73d95"
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
