class Scalariform < Formula
  desc "Scala source code formatter"
  homepage "https://github.com/scala-ide/scalariform"
  url "https://github.com/scala-ide/scalariform/releases/download/0.2.7/scalariform.jar"
  sha256 "b1d9177619424df561cc25b718c02923a2fd9bbdde94fb50583a49fd449b6808"

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
