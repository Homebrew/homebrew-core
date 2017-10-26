class Spotbugs < Formula
  desc "A tool for Java static analysis (FindBugs' successor)"
  homepage "https://spotbugs.github.io/"
  url "https://github.com/spotbugs/spotbugs/archive/3.1.0.tar.gz"
  sha256 "ac6169a551212756a05dd9c066ef9212653d8a99b754ef4dade6a7008f8ad781"
  head "https://github.com/spotbugs/spotbugs.git"

  depends_on "gradle" => :build
  depends_on :java => "1.8+"

  def install
    system "gradle build"
    system "gradle installDist"
    libexec.install Dir["spotbugs/build/install/spotbugs/*"]
    bin.install_symlink "#{libexec}/bin/spotbugs"
  end

  test do
    assert_match "3.1.0", shell_output("#{bin}/spotbugs -version", 1)
  end
end
