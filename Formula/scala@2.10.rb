class ScalaAT210 < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.10.7/scala-2.10.7.tgz"
  mirror "https://downloads.typesafe.com/scala/2.10.7/scala-2.10.7.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.10.7.tgz"
  sha256 "9283119916f6bb7714e076a2840ccf22d58819b355228ed1591ae6f76929f111"

  bottle :unneeded

  keg_only :versioned_formula

  option "with-docs", "Also install library documentation"
  option "with-src", "Also install sources for IDE support"

  depends_on :java => "1.8"

  resource "docs" do
    url "https://downloads.lightbend.com/scala/2.10.7/scala-docs-2.10.7.txz"
    mirror "https://www.scala-lang.org/files/archive/scala-docs-2.10.7.txz"
    sha256 "866a1fc287b4ac3e585b1b47ce59176ac3afff90c4543e106bc11ed8ff006d56"
  end

  resource "src" do
    url "https://github.com/scala/scala/archive/v2.10.7.tar.gz"
    sha256 "67d5941741f636f2177c1e558a98fbcfe1ba33d97a1fb373417d961299f4e296"
  end

  resource "completion" do
    url "https://raw.githubusercontent.com/scala/scala-tool-support/0a217bc/bash-completion/src/main/resources/completion.d/2.9.1/scala"
    sha256 "95aeba51165ce2c0e36e9bf006f2904a90031470ab8d10b456e7611413d7d3fd"
  end

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir["doc/*"]
    share.install "man"
    libexec.install "bin", "lib"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
    bash_completion.install resource("completion")
    doc.install resource("docs") if build.with? "docs"
    libexec.install resource("src").files("src") if build.with? "src"

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/"idea"
    idea.install_symlink libexec/"src", libexec/"lib"
    idea.install_symlink doc => "doc"
  end

  test do
    file = testpath/"Test.scala"
    file.write <<~EOS
      object Test {
        def main(args: Array[String]) {
          println(s"${2 + 2}")
        }
      }
    EOS

    out = shell_output("#{bin}/scala #{file}").strip
    # Shut down the compile server so as not to break Travis
    system bin/"fsc", "-shutdown"

    assert_equal "4", out
  end
end
