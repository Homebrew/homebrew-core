class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-1.0.3/uriparser-1.0.3.tar.bz2"
  sha256 "5daa0757f9866af8535398e7a49278faa6af1ff81695c9280c3a5a424bb328c6"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/uriparser/uriparser.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1cbba70827516fa28a03266652737f8cfbee50df23c5181296de6e4c8aca46c9"
    sha256 cellar: :any, arm64_tahoe:       "77cf4ecd0fc02cbf5ba23925ca64c34e7db3e176c959c9554255e1ceacf0967f"
    sha256 cellar: :any, arm64_sequoia:     "dcba49e906d4c9f7cc18585a0f8613e2b5afbb23d14457b4eb75a0d6f67d312f"
    sha256 cellar: :any, arm64_linux:       "13a3ec62e32a4e4e11b46009b3bff83a55ef37e4237c0616f0f84a34c004eaaa"
    sha256 cellar: :any, x86_64_linux:      "8fc29f375d7eb876e062d50a2578012d91cf7330624cfacd8c175febef818d32"
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
