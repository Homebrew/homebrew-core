class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/tika-app-1.24.1.jar"
  mirror "https://archive.apache.org/dist/tika/tika-app-1.24.1.jar"
  sha256 "e56d2e38be4755c78b511f316bda2a55af5c3b3b36e7e5536d3584c71239b187"

  bottle :unneeded

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/tika-server-1.24.1.jar"
    mirror "https://archive.apache.org/dist/tika/tika-server-1.24.1.jar"
    sha256 "466ae64b3f6fa52fe08bfa2b0339671e69988e84fd8bb0a359d345ff0ae024a3"
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
