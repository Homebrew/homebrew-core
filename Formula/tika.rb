class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.2.1/tika-app-2.2.1.jar"
  mirror "https://archive.apache.org/dist/tika/2.2.1/tika-app-2.2.1.jar"
  sha256 "9fc945031d45f1601f5cd55a560b412a88a5bb66b909506be0cc8110a52ffdf0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2654871c700d815f4b3fa8a8db634ab442a6fd512db639f99460c5032643e09f"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/2.2.1/tika-server-standard-2.2.1.jar"
    mirror "https://archive.apache.org/dist/tika/2.2.1/tika-server-standard-2.2.1.jar"
    sha256 "0bb16f8d07a41126a8ea7b94d9c715a1411a573d7c4217133b26972ee0f74c68"
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
