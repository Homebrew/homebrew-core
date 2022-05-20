class Tkdiff < Formula
  desc "Graphical side by side diff utility"
  homepage "https://tkdiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tkdiff/tkdiff/5.4/tkdiff-5-4.zip"
  version "5.4"
  sha256 "773b0b49fb7519260abd46f1cf6eef7c30042a8c025f3e8eee6422659485326e"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/tkdiff/v?(\d+(?:\.\d+)+)/[^"]+?\.zip}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "60c8912e850e5f029702a02e1c2551ab6e67cd626e8dd2e1a12573c2824e821c"
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
