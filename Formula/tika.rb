class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.7.0/tika-app-2.7.0.jar"
  mirror "https://archive.apache.org/dist/tika/2.7.0/tika-app-2.7.0.jar"
  sha256 "d901ed1dfbfbd151e0d208b3906434394922fc134747c88d462022c9c94257a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d86136672a2ab4e05aec55c8e0c3f48b1e7c87e783bb19d38d2f64f40e467f0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d86136672a2ab4e05aec55c8e0c3f48b1e7c87e783bb19d38d2f64f40e467f0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d86136672a2ab4e05aec55c8e0c3f48b1e7c87e783bb19d38d2f64f40e467f0c"
    sha256 cellar: :any_skip_relocation, ventura:        "d86136672a2ab4e05aec55c8e0c3f48b1e7c87e783bb19d38d2f64f40e467f0c"
    sha256 cellar: :any_skip_relocation, monterey:       "d86136672a2ab4e05aec55c8e0c3f48b1e7c87e783bb19d38d2f64f40e467f0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d86136672a2ab4e05aec55c8e0c3f48b1e7c87e783bb19d38d2f64f40e467f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e11bbd53a562a16f00e2703f75273b000abe4717d5954488ceaf8c9184e4d91a"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/2.7.0/tika-server-standard-2.7.0.jar"
    mirror "https://archive.apache.org/dist/tika/2.7.0/tika-server-standard-2.7.0.jar"
    sha256 "ce60c414184084ed0b0defe6673645453a2078c889e05195d56d9468a8e12011"
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
