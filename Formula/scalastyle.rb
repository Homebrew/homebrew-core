class Scalastyle < Formula
  desc "Run scalastyle from the command-line"
  homepage "http://www.scalastyle.org/command-line.html"
  url "https://oss.sonatype.org/content/repositories/releases/org/scalastyle/scalastyle_2.12/1.0.0/scalastyle_2.12-1.0.0-batch.jar"
  sha256 "e9dafd97be0d00f28c1e8bfcab951d0e5172b262a1d41da31d1fd65d615aedcb"

  # In a filename like `scalastyle_2.12-1.0.0-batch.jar`, the first version is
  # the Scala version (2.12) and the second is the Scalastyle version (1.0.0).
  livecheck do
    url :homepage
    regex(/href=.*?scalastyle[._-]v?\d+(?:\.\d+)+-(\d+(?:\.\d+)+)-batch\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1bd0fb8e674062b23048501e43c440b1ae9644313a466489b3116da0435b2d68"
  end

  depends_on "openjdk"

  resource "default_config" do
    url "https://raw.githubusercontent.com/scalastyle/scalastyle/v1.0.0/lib/scalastyle_config.xml"
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
