class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.9.2/tika-app-2.9.2.jar"
  mirror "https://archive.apache.org/dist/tika/2.9.2/tika-app-2.9.2.jar"
  sha256 "87e06f88c801fcb2beae5f15e707241edb14da468a154ad78be4e31ff982c3da"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "89e7b0f61d59630154d92918f17993767376d902658adcccfce945dcb05ce89f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c984095fbb5119c3890a5d26d8f038df3c988fb01195e67798b8618a137ee72c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0e4e7bc2b02f578215cb979d37707e9a87ab2d8089bb8aa7949b1fa3c8456f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b43e8a3a2bb76daf386787c0d795a6145478a86702fee8a55641f44d8db7dba8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5959b2521c67e9fdb26db8bf031cce7d92294b592981a3d85887064f35ebc5e8"
    sha256 cellar: :any_skip_relocation, ventura:        "565f680e1069d3fe614070b21bb2ec5b4669fca8d9dd540e3d865e54486b0d9f"
    sha256 cellar: :any_skip_relocation, monterey:       "76cb441941058bcc9893397e5455b4e90a3e847d8f42b87e4b3582a3b8d6eb17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac654af702bba434cab24d0f4fb3c837d757ff4f436b1e271449e6d13004e541"
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
    bin.write_jar_script libexec/"tika-server-standard-#{version}.jar", "tika-rest-server"
  end

  test do
    assert_match version.to_s, resource("server").version.to_s, "server resource out of sync with formula"
    pdf = test_fixtures("test.pdf")
    assert_equal "application/pdf\n", shell_output("#{bin}/tika --detect #{pdf}")

    port = free_port
    pid = fork do
      exec bin/"tika-rest-server", "--port=#{port}"
    end

    sleep 10
    response = shell_output("curl -s -i http://localhost:#{port}")
    assert_match "HTTP/1.1 200 OK", response
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
