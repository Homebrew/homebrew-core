class ScalaAT212 < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.12.20/scala-2.12.20.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.12.20.tgz"
  mirror "https://downloads.typesafe.com/scala/2.12.20/scala-2.12.20.tgz"
  sha256 "cc29d91ad390dc8e9a68d1e2ec6892711b64116f549fecd67a928361d33a39c0"
  license "Apache-2.0"

  livecheck do
    url "https://www.scala-lang.org/files/archive/"
    regex(/href=.*?scala[._-]v?(2\.12(?:\.\d+)+)(?:[._-]final)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c21bd2462426fdcdea41f7f960376c275dc101b2b32e7534647a2c3141081125"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    inreplace Dir["man/man1/scala{,c}.1"], "/usr/local", HOMEBREW_PREFIX

    rm(Dir["bin/*.bat"])
    doc.install Dir["doc/*"]
    share.install "man"
    libexec.install "bin", "lib"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/"idea"
    idea.install_symlink libexec/"src", libexec/"lib"
    idea.install_symlink doc => "doc"
  end

  def caveats
    <<~EOS
      To use with IntelliJ, set the Scala home to:
        #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/"Test.scala"
    file.write <<~SCALA
      object Test {
        def main(args: Array[String]) {
          println(s"${2 + 2}")
        }
      }
    SCALA

    out = shell_output("#{bin}/scala -nc #{file}").strip

    assert_equal "4", out
  end
end
