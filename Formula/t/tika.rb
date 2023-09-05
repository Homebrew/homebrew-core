class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.9.0/tika-app-2.9.0.jar"
  mirror "https://archive.apache.org/dist/tika/2.9.0/tika-app-2.9.0.jar"
  sha256 "390382b0ad31a7da55d83cce58538f4b59988eda6ebdf259459d4ef109df1b06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eecc14f26bdb4d50be34ebbbf862b14a093505e5051681553c07f4fb2e78c71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eecc14f26bdb4d50be34ebbbf862b14a093505e5051681553c07f4fb2e78c71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4eecc14f26bdb4d50be34ebbbf862b14a093505e5051681553c07f4fb2e78c71"
    sha256 cellar: :any_skip_relocation, ventura:        "4eecc14f26bdb4d50be34ebbbf862b14a093505e5051681553c07f4fb2e78c71"
    sha256 cellar: :any_skip_relocation, monterey:       "4eecc14f26bdb4d50be34ebbbf862b14a093505e5051681553c07f4fb2e78c71"
    sha256 cellar: :any_skip_relocation, big_sur:        "4eecc14f26bdb4d50be34ebbbf862b14a093505e5051681553c07f4fb2e78c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c4f3424c99b047b7efa897eb4928a23495b32f54fddd368a9b0cb0faa5f3a62"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/2.9.0/tika-server-standard-2.9.0.jar"
    mirror "https://archive.apache.org/dist/tika/2.9.0/tika-server-standard-2.9.0.jar"
    sha256 "ec1a17c1a23d72cb585ff3864fc8758182df6e86e636446ded0220784bcf85eb"
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
