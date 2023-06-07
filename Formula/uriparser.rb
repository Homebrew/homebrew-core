class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-0.9.7/uriparser-0.9.7.tar.bz2"
  sha256 "d27dea0c8b6f6fb9798f07caedef1cd96a6e3fc5c6189596774e19afa7ddded7"
  license "BSD-3-Clause"
  head "https://github.com/uriparser/uriparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e49771d86df067a567d44348b7c3778381346cccf8770fec3f47ea8b98257928"
    sha256 cellar: :any,                 arm64_monterey: "c246c0448bc8325163156ffc6f2978da545bb42724ba9cb9b17038292d1797e1"
    sha256 cellar: :any,                 arm64_big_sur:  "5a8a8595cee32186f8e6d180a183ffc63a0d105563b7ec3a32b5ba2fb95e8562"
    sha256 cellar: :any,                 ventura:        "4a9e68259e098e8b50c4d4f0c9966ec995803435138298e540e52b24a400c580"
    sha256 cellar: :any,                 monterey:       "24922aed78fc01f1b93cec54a5d7590689439128d18498131a327895bed353b0"
    sha256 cellar: :any,                 big_sur:        "71253e72c359702d184f83b86c9d1e8c0acd123e37e9c86fdc783e79d81149b3"
    sha256 cellar: :any,                 catalina:       "ca0d40acafadaf72bcbef19b7e44e3351a3fd0c552e9b066316779bd5b8abc4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ef786e370707bf3b8d646737116b723fc11fef8ecf8f2720bf107897c40ba33"
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
