class Tccutil < Formula
  desc "Utility to modify the macOS Accessibility Database (TCC.db)"
  homepage "https://github.com/jacobsalmela/tccutil"
  url "https://github.com/jacobsalmela/tccutil/archive/v1.2.11.tar.gz"
  sha256 "efff442bc4d1b50ededa0798c9e3a6a881ac3d06310148cf438d5e531f9d6564"
  license "GPL-2.0-or-later"
  head "https://github.com/jacobsalmela/tccutil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71f3e197c76e128e03b07e52d18f523d2ca19fa3f35e680e029175b755d2cef6"
  end

  depends_on :macos

  def install
    bin.install "tccutil.py" => "tccutil"
  end

  test do
    system "#{bin}/tccutil", "--help"
  end
end
