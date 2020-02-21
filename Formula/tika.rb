class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/tika-app-1.23.jar"
  mirror "https://archive.apache.org/dist/tika/tika-app-1.23.jar"
  sha256 "0c382d300442c3c2b84042e2c5b5cf2287583d4487c9b5c78eec58a625b54ae3"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/tika-server-1.23.jar"
    sha256 "9e95c7dada0f8ca81bf1b69192258a82890b645d389659330356fa3427005b6f"
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
