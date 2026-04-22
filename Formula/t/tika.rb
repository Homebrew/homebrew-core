class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/3.3.0/tika-app-3.3.0.jar"
  mirror "https://archive.apache.org/dist/tika/3.3.0/tika-app-3.3.0.jar"
  sha256 "df2d3013dc66ce6afcf3657046bbdd53145f90d30a645897ac43cd7de5528c4c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "99f6472d982d02331641405cf1f9a66f25b368332917769cac395fb882eabb33"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/3.3.0/tika-server-standard-3.3.0.jar"
    mirror "https://archive.apache.org/dist/tika/3.3.0/tika-server-standard-3.3.0.jar"
    sha256 "2aca63d25f84774d759de6e132ae7f5723e3ee2adf1d51f585658baba1335e9b"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "update `server` resource" if version != resource("server").version
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-#{version}.jar", "tika"

    libexec.install resource("server")
    bin.write_jar_script libexec/"tika-server-standard-#{version}.jar", "tika-rest-server"
  end

  service do
    run [opt_bin/"tika-rest-server"]
    working_dir var/"tika"
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_equal "application/pdf\n", shell_output("#{bin}/tika --detect #{pdf}")

    port = free_port
    pid = spawn bin/"tika-rest-server", "--port=#{port}"

    sleep 10
    response = shell_output("curl -s -i http://localhost:#{port}")
    assert_match "HTTP/1.1 200 OK", response
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
