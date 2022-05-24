class SaxonB < Formula
  desc "XSLT and XQuery processor"
  homepage "https://saxon.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/saxon/Saxon-B/9.1.0.8/saxonb9-1-0-8j.zip"
  version "9.1.0.8"
  sha256 "92bcdc4a0680c7866fe5828adb92c714cfe88dcf3fa0caf5bf638fcc6d9369b4"

  # We check the "Saxon-B" directory page since versions aren't present in the
  # RSS feed as of writing.
  livecheck do
    url "https://sourceforge.net/projects/saxon/files/Saxon-B/"
    strategy :page_match
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0d7ca97d0e55110811c6366183b021b8ec8906f323832ff2e7e302c288b5afc"
  end

  def install
    (buildpath/"saxon-b").install Dir["*.jar", "doc", "notices"]
    share.install Dir["*"]
  end
end
