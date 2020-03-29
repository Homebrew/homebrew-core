class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/tika-app-1.24.jar"
  mirror "https://archive.apache.org/dist/tika/tika-app-1.24.jar"
  sha256 "540dd9395d313e82cfb6ce9ba4f001220dcb962aea587f8ca220ac5be39db530"

  bottle :unneeded

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/tika-server-1.24.jar"
    sha256 "45f52079536386e5344e75ae77e7c70d92e28bd6a3229758df695b56d9200085"
  end

  def install
    libexec.install "tika-app-#{version}.jar"
    (bin/"tika").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/tika-app-#{version}.jar" "$@"
    EOS

    libexec.install resource("server")
    (bin/"tika-rest-server").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/tika-server-#{version}.jar" "$@"
    EOS
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_equal "application/pdf\n", shell_output("#{bin}/tika --detect #{pdf}")
  end
end
