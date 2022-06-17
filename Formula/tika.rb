class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.4.1/tika-app-2.4.1.jar"
  mirror "https://archive.apache.org/dist/tika/2.4.1/tika-app-2.4.1.jar"
  sha256 "ac0f4b632a9d7933787089f0f08acedb06b53f1bf320ec2c81ea0b5879407c58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d917dc463b40bbbfc0071d44697c48f8a36144e5e3d1f9321a956fdc32c2c372"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/2.4.0/tika-server-standard-2.4.0.jar"
    mirror "https://archive.apache.org/dist/tika/2.4.0/tika-server-standard-2.4.0.jar"
    sha256 "12b6ac5824d0e8e31b66a3a0c662b3cddd6e690cef0355e7efa11095cb67d874"
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
