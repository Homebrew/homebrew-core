class Sbuild < Formula
  desc "Scala-based build system"
  homepage "http://sbuild.org/"
  url "http://sbuild.org/uploads/sbuild/0.7.7/sbuild-0.7.7-dist.zip"
  mirror "https://github.com/SBuild-org/SBuild-org.github.io/raw/master/uploads/sbuild/0.7.7/sbuild-0.7.7-dist.zip"
  sha256 "606bc09603707f31d9ca5bc306ba01b171f8400e643261acd28da7a1a24dfb23"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?sbuild[._-]v?(\d+(?:\.\d+)+)(?:[._-]dist)?\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c54295e4c98758e18d7d5a5ffd76185e429561e59b4a716d25d3482e2546eeb"
  end

  depends_on "openjdk"

  def install
    # Delete unsupported VM option 'MaxPermSize', which is unrecognized in Java 17
    # Remove this line once upstream removes it from bin/sbuild
    inreplace "bin/sbuild", /-XX:MaxPermSize=[^ ]*/, ""

    libexec.install Dir["*"]
    chmod 0755, libexec/"bin/sbuild"
    (bin/"sbuild").write_env_script libexec/"bin/sbuild", Language::Java.overridable_java_home_env
  end

  test do
    expected = <<~EOS
      import de.tototec.sbuild._

      @version("#{version}")
      class SBuild(implicit _project: Project) {

        Target("phony:clean") exec {
          Path("target").deleteRecursive
        }

        Target("phony:hello") help "Greet me" exec {
          println("Hello you")
        }

      }
    EOS
    system bin/"sbuild", "--create-stub"
    assert_equal expected, (testpath/"Sbuild.scala").read
  end
end
