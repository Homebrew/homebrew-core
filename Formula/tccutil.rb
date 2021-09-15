class Tccutil < Formula
  desc "Utility to modify the macOS Accessibility Database (TCC.db)"
  homepage "https://github.com/jacobsalmela/tccutil"
  url "https://github.com/jacobsalmela/tccutil/archive/v1.2.10.tar.gz"
  sha256 "8a6f9961b37322dee0f20a70b4299a23f16f3023a549147a4410e3f322dbfa22"
  license "GPL-2.0-or-later"
  head "https://github.com/jacobsalmela/tccutil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2f9f812b661c081405e4dfd04a1c6b22003898d6c978e4af797e6d079ee803ce"
  end

  depends_on :macos

  def install
    bin.install "tccutil.py" => "tccutil"
  end

  test do
    system "#{bin}/tccutil", "--help"
  end
end
