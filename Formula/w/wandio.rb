class Wandio < Formula
  desc "Transparently read from and write to zip, bzip2, lzma or zstd archives"
  homepage "https://github.com/LibtraceTeam/wandio"
  url "https://github.com/LibtraceTeam/wandio/archive/refs/tags/4.2.6-1.tar.gz"
  version "4.2.6"
  sha256 "f035d4d6beadf7a7e5619fb73db5a84d338008b5f4d6b1b8843619547248ec73"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.gsub(/-1$/, "") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5cc4f12e0470409771792e2cb729aae66e6471d2a21758923c79aa21639209b1"
    sha256 cellar: :any,                 arm64_sequoia:  "685add7045c60ef524de06b753866b39fcb9a35b25dc57041609b8661b2bf545"
    sha256 cellar: :any,                 arm64_sonoma:   "3653ed92c97fe1d0574bb854a16e54fce8c25740a75aaf6989bc065fbfe5477b"
    sha256 cellar: :any,                 arm64_ventura:  "ad3894a632efe3456a375e96358f0f1719a57856d8bce53d4d7f13095a3b62f8"
    sha256 cellar: :any,                 arm64_monterey: "755dd52c90ec7a3db4b475f24ebe60805b0d1ca1812cc65a2764e12bdbbcba54"
    sha256 cellar: :any,                 arm64_big_sur:  "036e3e338d06911199aee8d98a813cdfb89e5cf462193a7073f881e81bbe81aa"
    sha256 cellar: :any,                 sonoma:         "e4169552ae06821d31de301c7a2eec3d7bb733c72684386044e403521c4d531a"
    sha256 cellar: :any,                 ventura:        "3309dcd938ca538d3d9f35added3121069cee9f269fe95a153e0d0739a6cbe6d"
    sha256 cellar: :any,                 monterey:       "cb8eae9bae43a9cb8e6a39aa0a130170a0c41e5451fde7071aba2bc858ce5bd8"
    sha256 cellar: :any,                 big_sur:        "e1f3714ad297b93d897a9e291793e458084f380b253e7082f612dc35990464a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5048ccd59624fe77b17eba9d1ebb78f4ded274bd2b4f94046d71b42e2edc580f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac5e2d66c128660db66748acbc77d1623cc500b3e140a253e2fb9c9f4f86c79d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "lz4"
  depends_on "lzo"
  depends_on "xz" # For LZMA
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "./bootstrap.sh"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-http"
    system "make", "install"
  end

  test do
    system bin/"wandiocat", "-z", "9", "-Z", "gzip", "-o", "test.gz",
      test_fixtures("test.png"), test_fixtures("test.pdf")
    assert_path_exists testpath/"test.gz"
  end
end
