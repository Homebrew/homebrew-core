class Tkdiff < Formula
  desc "Graphical side by side diff utility"
  homepage "https://tkdiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tkdiff/tkdiff/5.5.2/tkdiff-5-5-2.zip"
  version "5.5.2"
  sha256 "31718411fa181ea4a6c9c7f8eea115a7b86c50dff5a1a070bc7ad26381d7176b"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/tkdiff/v?(\d+(?:\.\d+)+)/[^"]+?\.zip}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "25a9074dad2f48932c00dea0ab2452f1a0ed53bacf96d40a6cae4b106cf8821e"
  end

  uses_from_macos "tcl-tk"

  def install
    bin.install "tkdiff"
  end

  test do
    # Fails with: no display name and no $DISPLAY environment variable on GitHub Actions
    system "#{bin}/tkdiff", "--help" if OS.mac?
  end
end
