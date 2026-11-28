class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/4.2.0/tika-app-4.2.0.zip"
  mirror "https://archive.apache.org/dist/tika/4.2.0/tika-app-4.2.0.zip"
  sha256 "c610c35c3ec09855be28fa27c64f0488864da6f2006c054aad59eb6ded010ccf"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "6b866ed7bc3f25167cf13227fb18c29f1aceaef389a5a194c2c41e3c4daee366"
    sha256 cellar: :any_skip_relocation, all: "cc2780dea7bdf3384f6ffcf17319b2412b0c3bec0a1344986c0a7c29501294d7"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/4.2.0/tika-server-standard-4.2.0.zip"
    mirror "https://archive.apache.org/dist/tika/4.2.0/tika-server-standard-4.2.0.zip"
    sha256 "4cc31eefdea6739811ce7451a7a8b9ee782d5b7799a0554b7d4f599896edbef1"

    livecheck do
      formula :parent
    end
  end

  allow_network_access! :test

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
    with_test_process(bin/"tika-rest-server", "--port=#{port}") do
      sleep 10
      response = shell_output("curl -s -i http://localhost:#{port}")
      assert_match "HTTP/1.1 200 OK", response
    end
  end
end
