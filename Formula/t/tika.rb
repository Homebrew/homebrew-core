class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.9.2/tika-app-2.9.2.jar"
  mirror "https://archive.apache.org/dist/tika/2.9.2/tika-app-2.9.2.jar"
  sha256 "87e06f88c801fcb2beae5f15e707241edb14da468a154ad78be4e31ff982c3da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef11546bb8c34e9bf78871f9838b5d9afc65c0bae5ba1ddcab64d9211e834ed2"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/2.9.2/tika-server-standard-2.9.2.jar"
    mirror "https://archive.apache.org/dist/tika/2.9.2/tika-server-standard-2.9.2.jar"
    sha256 "379cdb319b80618d166057beecdb445b677d099c438ec026e5810239c1cd03d5"
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
