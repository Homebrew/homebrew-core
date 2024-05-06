class Topfew < Formula
  desc "Finds the field values which appear most often in a stream of records"
  homepage "https://github.com/timbray/topfew"
  url "https://github.com/timbray/topfew/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ac277366c1f12e88b7a050a11d8eb35b1b518b1b94b0ec58a34ff935f76d9269"
  license "GPL-3.0-or-later"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "1 bar", pipe_output("#{bin}/topfew -f 2", "foo bar\n")
  end
end
