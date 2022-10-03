class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.5.0/tika-app-2.5.0.jar"
  mirror "https://archive.apache.org/dist/tika/2.5.0/tika-app-2.5.0.jar"
  sha256 "9eb0a20c5a6f21940bb16fa4d41e6b621f4715e0326e4d4690b45e002b992107"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "564a789279ca0c9ce9adb8d2c8ff00ec042dd2a862f8c1a74e3bec72b9226780"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/2.4.1/tika-server-standard-2.4.1.jar"
    mirror "https://archive.apache.org/dist/tika/2.4.1/tika-server-standard-2.4.1.jar"
    sha256 "7dd0ce47f8943e8d04b5f7c79a2d0ab131be18d11512a3e3173a60d530df08dc"
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
