class Scalariform < Formula
  desc "Scala source code formatter"
  homepage "https://github.com/scala-ide/scalariform"
  url "https://github.com/scala-ide/scalariform/releases/download/0.2.10/scalariform.jar"
  sha256 "59d7c26f26c13bdbc27e3011da244f01001d55741058062f49e4626862b7991e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0a155625340add1d947b67289ee0ebfad84655735801562fe67ed853840ec92a"
  end

  head do
    url "https://github.com/scala-ide/scalariform.git"
    depends_on "sbt" => :build
  end

  depends_on "openjdk"

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
