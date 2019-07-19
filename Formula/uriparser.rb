class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  head "https://github.com/uriparser/uriparser.git"

  stable do
    url "https://github.com/uriparser/uriparser/releases/download/uriparser-0.9.3/uriparser-0.9.3.tar.bz2"
    sha256 "28af4adb05e811192ab5f04566bebc5ebf1c30d9ec19138f944963d52419e28f"

    # Upstream fix, will be integrated in next release
    # https://github.com/uriparser/uriparser/issues/67
    patch do
      url "https://github.com/uriparser/uriparser/commit/f870e6c68696a6018702caa5c8a2feba9b0f99fa.diff?full_index=1"
      sha256 "c609224fc996b6231781e1beba4424c2237fc5e49e2de049b344d926db0630f7"
    end
  end

  bottle do
    cellar :any
    sha256 "e54bac5e1cf6a1ed3f87e42f56f0ff2f4602e22cf6113bc03d82a6ae12b13f76" => :mojave
    sha256 "27649c5b2c692596c9811ab872b1b82e09ccb67dbff0a048de7137134aff81e8" => :high_sierra
    sha256 "a3ee937d18ead7330f7cf6dfbf5a63ac41dbb5e9d7e68450e3b07ff54c75d80f" => :sierra
  end

  depends_on "cmake" => :build

  conflicts_with "libkml", :because => "both install `liburiparser.dylib`"

  def install
    system "cmake", ".", "-DURIPARSER_BUILD_TESTS=OFF", "-DURIPARSER_BUILD_DOCS=OFF", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    expected = <<~EOS
      uri:          https://brew.sh
      scheme:       https
      hostText:     brew.sh
      absolutePath: false
                    (always false for URIs with host)
    EOS
    assert_equal expected, shell_output("#{bin}/uriparse https://brew.sh").chomp
  end
end
