class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.3.0/tika-app-2.3.0.jar"
  mirror "https://archive.apache.org/dist/tika/2.3.0/tika-app-2.3.0.jar"
  sha256 "73e93aa3b6325227d4f1da6ce9d18695437240b45f3610337c3e7faa084274ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "02c5b267e415fe43cee8acf467e8d1ec340c3cf57260717e9a62f58416ab3bdb"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/2.3.0/tika-server-standard-2.3.0.jar"
    mirror "https://archive.apache.org/dist/tika/2.3.0/tika-server-standard-2.3.0.jar"
    sha256 "45df8a64a5090d13109d30644a00f705282bfea0cae0948e93b2ec834c14b192"
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
