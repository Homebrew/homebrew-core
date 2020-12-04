class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/tika-app-1.25.jar"
  mirror "https://archive.apache.org/dist/tika/tika-app-1.25.jar"
  sha256 "7a9965d6f69ef1dc5189179f3ac95ca243b07d9f80c63b753219f9ca1261e6df"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle :unneeded

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/tika-server-1.24.1.jar"
    mirror "https://archive.apache.org/dist/tika/tika-server-1.24.1.jar"
    sha256 "466ae64b3f6fa52fe08bfa2b0339671e69988e84fd8bb0a359d345ff0ae024a3"
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
