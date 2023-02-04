class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.7.0/tika-app-2.7.0.jar"
  mirror "https://archive.apache.org/dist/tika/2.7.0/tika-app-2.7.0.jar"
  sha256 "d901ed1dfbfbd151e0d208b3906434394922fc134747c88d462022c9c94257a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "97587878afbb5ee685470087e5d6848a02500b0a22b93cf302f42dcae2c6d64a"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/2.7.0/tika-server-standard-2.7.0.jar"
    mirror "https://archive.apache.org/dist/tika/2.7.0/tika-server-standard-2.7.0.jar"
    sha256 "ce60c414184084ed0b0defe6673645453a2078c889e05195d56d9468a8e12011"
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
