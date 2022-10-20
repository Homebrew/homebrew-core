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
    sha256 cellar: :any_skip_relocation, all: "59fd6426bcef5f58c200294a6bff1736866e5844d301fa3a8cd8d33cebb81a1b"
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
