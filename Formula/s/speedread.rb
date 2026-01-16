class Speedread < Formula
  desc "Simple terminal-based rapid serial visual presentation (RSVP) reader"
  homepage "https://github.com/pasky/speedread"
  license "MIT"
  head "https://github.com/pasky/speedread.git", branch: "master"

  stable do
    url "https://github.com/pasky/speedread/archive/refs/tags/v1.0.tar.gz"
    sha256 "a65f5bec427e66893663bcfc49a22e43169dd35976302eaed467eec2a5aafc1b"

    # Fix error with macOS 11 Perl: "The encoding pragma is no longer supported"
    # Remove this in next release
    patch do
      url "https://github.com/pasky/speedread/commit/24c3946d14f7f310a7012be1f9d3cbccf0b16765.patch?full_index=1"
      sha256 "df8d576ad920f32c6dc3e934f4883f7b2d43fb7d2453bb007620513100df076a"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "84a404d8c1cbdb6d69501b347a9e50f87a34cce2136ebb12f97d4ab9b117443a"
  end

  def install
    bin.install "speedread"
  end

  test do
    system bin/"speedread", "-w 1000", "<(echo This is a test)"
  end
end
