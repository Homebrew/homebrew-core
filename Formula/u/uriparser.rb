class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-1.0.2/uriparser-1.0.2.tar.bz2"
  sha256 "dd2e4843f43de6f5aedf430e530f1e2d159eba8ca4d64c2787af1c20f707a9e4"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/uriparser/uriparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d65dd8ec22ad8983a030d28f0860ed787540977f63f54991a0c34f3af59ff54d"
    sha256 cellar: :any,                 arm64_sequoia: "c493b8bf01407748aee749e76282fd8d28b75609d0bc190d082de21c07195213"
    sha256 cellar: :any,                 arm64_sonoma:  "f3bbbc62b739c550d0273b4a4f8cb6e0f613b812ee1be4268089963b59dd7ee3"
    sha256 cellar: :any,                 sonoma:        "d88ca97e3db34d38a4ac3698da4fb1ce5de61cbb46b5c754407cbb5cc56332e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "814a3e8a6d0c3970c05b91c41776b5e6c88ce0c75ddaf97f842c14beb109c423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92d362009241b6bb912579151fb98480863663a59f9bd586cee65485be998f0f"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DURIPARSER_BUILD_TESTS=OFF
      -DURIPARSER_BUILD_DOCS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
