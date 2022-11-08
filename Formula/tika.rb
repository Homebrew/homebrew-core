class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.6.0/tika-app-2.6.0.jar"
  mirror "https://archive.apache.org/dist/tika/2.6.0/tika-app-2.6.0.jar"
  sha256 "fa289b58a5c1bb531ace78324625512a9448aa8472b5eb88b65988964048815a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "663c7ada0ceb2c96343952de70086642365227cd39e4f51fda093c467f7998ee"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/2.5.0/tika-server-standard-2.5.0.jar"
    mirror "https://archive.apache.org/dist/tika/2.5.0/tika-server-standard-2.5.0.jar"
    sha256 "3866ce84f8f889d410a369bc0a3682efa43305140e68574a2d76fab9a56c43b2"
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
