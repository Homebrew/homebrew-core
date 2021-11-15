class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.1.0/tika-app-2.1.0.jar"
  mirror "https://archive.apache.org/dist/tika/2.1.0/tika-app-2.1.0.jar"
  sha256 "0a93cdffebe1f1f0aca5b203538cafd66579a65409a8d565b93d3b8150e4e69c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8286072b39465e702e61c8992a642058310816112f82e126a43116c3c419d523"
    sha256 cellar: :any_skip_relocation, big_sur:       "8286072b39465e702e61c8992a642058310816112f82e126a43116c3c419d523"
    sha256 cellar: :any_skip_relocation, catalina:      "8286072b39465e702e61c8992a642058310816112f82e126a43116c3c419d523"
    sha256 cellar: :any_skip_relocation, mojave:        "8286072b39465e702e61c8992a642058310816112f82e126a43116c3c419d523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55267fe3a78db796ced8d71ad0e0951c1b54937f6522bdf31178e16182ec8bbf"
    sha256 cellar: :any_skip_relocation, all:           "84ec65ecc02f04875be46cd0143dfbbb33c2fff642cb5b0f70936ae68e8264b8"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/2.1.0/tika-server-standard-2.1.0.jar"
    mirror "https://archive.apache.org/dist/tika/2.1.0/tika-server-standard-2.1.0.jar"
    sha256 "845c3e2983255dd080bb140d4b7a8d3180c900c26f034ced1ab72530e81f5b61"
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
