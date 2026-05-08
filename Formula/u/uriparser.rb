class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-1.0.1/uriparser-1.0.1.tar.bz2"
  sha256 "f6cff90438c6605131f36f703bd4c6bf638b7266a52cf9aaf46cf9e11e5f77f6"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/uriparser/uriparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "22302d9a7316f526ea2e885a079ca062abc55c2315b6870ca9c94d43979f2db4"
    sha256 cellar: :any,                 arm64_sequoia: "bae6c2c33ec09e5eea5a94cf724fcc6da0e1d58c85e8eccb23ca3b88044f695b"
    sha256 cellar: :any,                 arm64_sonoma:  "9afc9000e98490afb2b4215840b4f66af09429d68a045f7de1b4a3dcd9509d02"
    sha256 cellar: :any,                 sonoma:        "85d419c11047d19e2369bb722e15466db15cf73800e30888fa65aef6342fc653"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a072c52e160da557777bd7e11284066b1fac5b9b8bbd9484535ddf336ff84da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b2addcdc00d74e12958fbdbb64c2b1c77d7615405fc1bc2d0d88bff4690fa38"
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
