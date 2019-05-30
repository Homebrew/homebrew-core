class Scalariform < Formula
  desc "Scala source code formatter"
  homepage "https://github.com/scala-ide/scalariform"
  url "https://github.com/scala-ide/scalariform/releases/download/0.2.8/scalariform.jar"
  sha256 "17ce7a7189887bd015b0a49b815a788121d9d1d3f9cde57e329829d02334fd7f"

  head do
    url "https://github.com/scala-ide/scalariform.git"
    depends_on "sbt" => :build
  end

  bottle :unneeded

  def install
    if build.head?
      system "sbt", "project cli", "assembly"
      libexec.install Dir["cli/target/scala-*/cli-assembly-*.jar"]
      bin.write_jar_script Dir[libexec/"cli-assembly-*.jar"][0], "scalariform"
    else
      libexec.install "scalariform.jar"
      bin.write_jar_script libexec/"scalariform.jar", "scalariform"
    end
  end

  test do
    before_data = <<~EOS
      def foo() {
      println("Hello World")
      }
    EOS

    after_data = <<~EOS
      def foo() {
         println("Hello World")
      }
    EOS

    (testpath/"foo.scala").write before_data
    system bin/"scalariform", "-indentSpaces=3", testpath/"foo.scala"
    assert_equal after_data, (testpath/"foo.scala").read
  end
end
