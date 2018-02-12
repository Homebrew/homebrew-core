class ScalaAT210 < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.10.6/scala-2.10.6.tgz"
  mirror "https://downloads.typesafe.com/scala/2.10.6/scala-2.10.6.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.10.6.tgz"
  sha256 "54adf583dae6734d66328cafa26d9fa03b8c4cf607e27b9f3915f96e9bcd2d67"
  revision 2

  bottle :unneeded

  keg_only :versioned_formula

  option "with-docs", "Also install library documentation"
  option "with-src", "Also install sources for IDE support"

  depends_on :java => "1.8"

  resource "docs" do
    url "https://downloads.lightbend.com/scala/2.10.6/scala-docs-2.10.6.txz"
    mirror "https://www.scala-lang.org/files/archive/scala-docs-2.10.6.txz"
    sha256 "e9b5694255607ba069dcc0faa3ab1490164115ae000129c03100b196fce2025a"
  end

  resource "src" do
    url "https://github.com/scala/scala/archive/v2.10.6.tar.gz"
    sha256 "06d7467ff628ebac615c5e60af155e0b4cbbf4c31d10c03a45e9615d5b1e0420"
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
