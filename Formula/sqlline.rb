class Sqlline < Formula
  desc "Command-line shell for issuing SQL to relational databases via JDBC"
  homepage "https://github.com/julianhyde/sqlline"
  url "https://search.maven.org/remotecontent?filepath=sqlline/sqlline/1.11.0/sqlline-1.11.0-jar-with-dependencies.jar"
  sha256 "725dbbe1e6b42399ad3741c522c8351d706c0b06623390ad425729f82901d4da"
  license "BSD-3-Clause"

  depends_on "openjdk"

  def install
    libexec.install "sqlline-#{version}-jar-with-dependencies.jar"
    bin.write_jar_script libexec/"sqlline-#{version}-jar-with-dependencies.jar", "sqlline"
  end

  test do
    assert_match "sqlline version #{version}\n", shell_output("#{bin}/sqlline -e '!quit' 2>&1")
  end
end
