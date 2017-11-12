class Scalastyle < Formula
  desc "Run scalastyle from the command-line"
  homepage "http://www.scalastyle.org/command-line.html"
  url "https://oss.sonatype.org/content/repositories/releases/org/scalastyle/scalastyle_2.12/1.0.0/scalastyle_2.12-1.0.0-batch.jar"
  sha256 "e9dafd97be0d00f28c1e8bfcab951d0e5172b262a1d41da31d1fd65d615aedcb"

  bottle :unneeded

  resource "default_config" do
    url "https://raw.githubusercontent.com/scalastyle/scalastyle/v1.0.0/lib/scalastyle_config.xml"
    version "1.0.0"
    sha256 "6ce156449609a375d973cc8384a17524e4538114f1747efc2295cf4ca473d04e"
  end

  def install
    libexec.install "scalastyle_2.12-#{version}-batch.jar"
    bin.write_jar_script("#{libexec}/scalastyle_2.12-#{version}-batch.jar", "scalastyle")
  end

  test do
    (testpath/"test.scala").write <<~EOS
      object HelloWorld {
        def main(args: Array[String]) {
          println("Hello")
        }
      }
    EOS
    testpath.install resource("default_config")
    system bin/"scalastyle", "--config", "scalastyle_config.xml", testpath/"test.scala"
  end
end
