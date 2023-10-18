class ScalaAT213 < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.13.12/scala-2.13.12.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.13.12.tgz"
  mirror "https://downloads.typesafe.com/scala/2.13.12/scala-2.13.12.tgz"
  sha256 "afe7e6fb59e3c88457e99f7018730e52fba27c8d15e3d7154f72968206ca8719"
  license "Apache-2.0"

  livecheck do
    url "https://www.scala-lang.org/files/archive/"
    regex(/href=.*?scala[._-]v?(2\.13(?:\.\d+)+)(?:[._-]final)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb864999538aabed7a9fc26c7282a960a1de978b9a3e92de80194793e5f47efa"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    # Replace `/usr/local` references for uniform bottles
    inreplace Dir["man/man1/scala{,c}.1"], "/usr/local", HOMEBREW_PREFIX
    rm Dir["bin/*.bat"]
    doc.install (buildpath/"doc").children
    share.install "man"
    libexec.install "lib"
    prefix.install "bin"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/"idea"
    idea.install_symlink libexec/"lib"
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
    file.write <<~EOS
      object Test {
        def main(args: Array[String]): Unit = {
          println(s"${2 + 2}")
        }
      }
    EOS

    out = shell_output("#{bin}/scala #{file}").strip

    assert_equal "4", out
  end
end
