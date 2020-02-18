class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tika/tika-app-1.23.jar"
  mirror "https://archive.apache.org/dist/tika/tika-app-1.23.jar"
  sha256 "0c382d300442c3c2b84042e2c5b5cf2287583d4487c9b5c78eec58a625b54ae3"

  bottle :unneeded

  depends_on :java => "1.7+"

  resource "server" do
    url "https://www.apache.org/dyn/closer.cgi?path=tika/tika-server-1.23.jar"
    sha256 "9e95c7dada0f8ca81bf1b69192258a82890b645d389659330356fa3427005b6f"
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
