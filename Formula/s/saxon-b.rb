class SaxonB < Formula
  desc "XSLT and XQuery processor"
  homepage "https://saxon.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/saxon/Saxon-B/9.1.0.8/saxonb9-1-0-8j.zip"
  version "9.1.0.8"
  sha256 "92bcdc4a0680c7866fe5828adb92c714cfe88dcf3fa0caf5bf638fcc6d9369b4"
  # The `cannot_represent` is for an older (2007) variation of Unicode-DFS-2015 (see notices/UNICODE.txt for details)
  license all_of: ["MPL-1.0", "MPL-1.1", "Apache-2.0", "BSD-3-Clause", "HPND-sell-variant", "X11", :cannot_represent]

  # Saxon-B was replaced by Saxon-HE (`saxon` formula) in version 9.2.
  # New maintenance releases are no longer available on SourceForge.
  #
  # Ref: https://www.saxonica.com/html/documentation12/changes/v9.2/installation.html
  # Ref: https://www.saxonica.com/download/information.xml#earlier
  # Ref: https://github.com/Saxonica/Saxon-Archive
  # Ref: https://github.com/Homebrew/legacy-homebrew/pull/10634
  livecheck do
    skip "Not actively developed or maintained"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "689001c5df91d0cf80e9ea2d72a5a8ae88abb45142dd47bf9797728d215d2139"
  end

  def install
    (buildpath/"saxon-b").install Dir["*.jar", "doc", "notices"]
    share.install Dir["*"]
  end
end
