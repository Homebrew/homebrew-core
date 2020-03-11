class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/4.3.1.tar.gz"
  sha256 "4abcb9c9dff24eab44d64d392e115ae774ab1ad90d04f2c983d96d7d7f9476aa"
  head "https://github.com/radare/radare2.git"

  bottle do
    sha256 "aabcfadbe38b92cf872e5da3f93ab8d88ff0e77ccde4e16336d9dae2111ad475" => :catalina
    sha256 "179ded7fc8f0f8eaa61043eaadf3301130fd7a2962ad16edd957487e47e7b5ac" => :mojave
    sha256 "28879d87a87a5881f362af8944a8063801ebc810b2cd0aaf6e047cba8214bca7" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -version")
  end
end
