class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.1.0/tika-app-2.1.0.jar"
  mirror "https://archive.apache.org/dist/tika/2.1.0/tika-app-2.1.0.jar"
  sha256 "0a93cdffebe1f1f0aca5b203538cafd66579a65409a8d565b93d3b8150e4e69c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1cfc903c9d42479276b3faadd9510cd9d14f6b07857c1115fdd1152f26020fd7"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/tika-server-1.26.jar"
    mirror "https://archive.apache.org/dist/tika/tika-server-1.26.jar"
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
