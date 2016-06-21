class Scalariform < Formula
  desc "Scala source code formatter"
  homepage "https://github.com/daniel-trinh/scalariform"
  url "https://github.com/daniel-trinh/scalariform/releases/download/0.1.7/scalariform.jar"
  sha256 "8cb179402a7960310a8c6639a20ab94277ec3052cb75ea3ddba31265d070f0d6"

  head do
    url "https://github.com/daniel-trinh/scalariform.git"
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
    before_data = <<-EOS.undent
      def foo() {
      println("Hello World")
      }
    EOS

    after_data = <<-EOS.undent
      def foo() {
         println("Hello World")
      }
    EOS

    (testpath/"foo.scala").write before_data
    system bin/"scalariform", "-indentSpaces=3", testpath/"foo.scala"
    assert_equal after_data, (testpath/"foo.scala").read
  end
end
