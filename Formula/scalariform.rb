class Scalariform < Formula
  desc "Scala source code formatter"
  homepage "https://github.com/scala-ide/scalariform"
  url "https://github.com/scala-ide/scalariform/releases/download/0.2.6/scalariform.jar"
  sha256 "0cd28ba1a8725527572f75f7b23bca8b9f55c945e01592d5968c1383113bf7a4"

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
