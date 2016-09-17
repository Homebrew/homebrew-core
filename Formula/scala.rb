class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"

  stable do
    url "https://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.tgz"
    sha256 "87fc86a19d9725edb5fd9866c5ee9424cdb2cd86b767f1bb7d47313e8e391ace"

    depends_on :java => "1.6+"

    resource "docs" do
      url "https://downloads.lightbend.com/scala/2.11.8/scala-docs-2.11.8.zip"
      sha256 "73bd44375ebffd5f401950a11d78addc52f8164c30d8528d26c82c1f819cfc16"
    end

    resource "src" do
      url "https://github.com/scala/scala/archive/v2.11.8.tar.gz"
      sha256 "4f11273b4b3c771019253b2c09102245d063a7abeb65c7b1c4519bd57605edcf"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "39b0710925d388a1a5f61453702c8d4816525c21a7369b120f46c72decf0eeed" => :sierra
    sha256 "05a10bbcce35c526dba3b475bc53ad076b7b1bb5088751eec7a962f718274308" => :el_capitan
    sha256 "2da6cd4894a9291c2fb0a341cc84f96522291d76644e35c9f00cf710eb6cb417" => :yosemite
    sha256 "ddd6e527a6e93c326d761c61d9811648c1eba82044ef24ded32837fa37581c16" => :mavericks
  end

  devel do
    url "http://www.scala-lang.org/files/archive/scala-2.12.0-RC1.tgz"
    sha256 "ac4f05a75306b241a60a57dfabd8c5adec15435f0f380688ee5eb1caaa600192"
    version "2.12.0-RC1"

    depends_on :java => "1.8+"

    resource "docs" do
      url "http://www.scala-lang.org/files/archive/scala-docs-2.12.0-RC1.zip"
      sha256 "4c1deb463b5d9e4ec0915b90557cc9e856609262f2cbeaeb6f248ae2054ea41d"
      version "2.12.0-RC1"
    end

    resource "src" do
      url "https://github.com/scala/scala/archive/v2.12.0-RC1.tar.gz"
      sha256 "55219e9d25c28a7c3966c6333b06c7d718be89bc5f8310b2428d47c9f38be851"
      version "2.12.0-RC1"
    end
  end

  option "with-docs", "Also install library documentation"
  option "with-src", "Also install sources for IDE support"

  resource "completion" do
    url "https://raw.githubusercontent.com/scala/scala-dist/v2.11.4/bash-completion/src/main/resources/completion.d/2.9.1/scala"
    sha256 "95aeba51165ce2c0e36e9bf006f2904a90031470ab8d10b456e7611413d7d3fd"
  end

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir["doc/*"]
    share.install "man"
    libexec.install "bin", "lib"
    bin.install_symlink Dir["#{libexec}/bin/*"]
    bash_completion.install resource("completion")
    doc.install resource("docs") if build.with? "docs"
    libexec.install resource("src").files("src") if build.with? "src"

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/"idea"
    idea.install_symlink libexec/"src", libexec/"lib"
    idea.install_symlink doc => "doc"
  end

  def caveats; <<-EOS.undent
    To use with IntelliJ, set the Scala home to:
      #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/"Test.scala"
    file.write <<-EOS.undent
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
