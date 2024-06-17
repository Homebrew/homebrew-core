class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://search.maven.org/remotecontent?filepath=org/gridkit/jvmtool/sjk-plus/0.23/sjk-plus-0.23.jar"
  sha256 "6aab07cdf0ecad394e225a1f47d7342cb23bfd8b7d5c65c945f81835363ec937"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "36ab1fd7c194fb972a831ffd10917c79a2091802cffd4e896f8b36a609ce5118"
  end

  depends_on "openjdk"

  def install
    libexec.install "sjk-plus-#{version}.jar"
    bin.write_jar_script libexec/"sjk-plus-#{version}.jar", "sjk"
  end

  test do
    system bin/"sjk", "jps"
  end
end
