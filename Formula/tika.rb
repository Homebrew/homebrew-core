class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.4.0/tika-app-2.4.0.jar"
  mirror "https://archive.apache.org/dist/tika/2.4.0/tika-app-2.4.0.jar"
  sha256 "1dcd6547c0e703144bf2f3b53bd2bf074fbe72147845855af3529cb3a110cec7"
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
