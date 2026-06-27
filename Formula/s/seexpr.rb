class Seexpr < Formula
  desc "Embeddable expression evaluation engine"
  homepage "https://wdas.github.io/SeExpr/"
  url "https://github.com/wdas/SeExpr/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "1e4cd35e6d63bd3443e1bffe723dbae91334c2c94a84cc590ea8f1886f96f84e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "d4fedca978d91b1a42b576ef1f225c684897945f78293fadee966d41f2217bdf"
    sha256 cellar: :any,                 arm64_sequoia: "3614da63f916d5bcf3ebfbb5e707891cce153aff309b701a08d689e8c973b50e"
    sha256 cellar: :any,                 arm64_sonoma:  "889e644f77e922e3afe2ed53c6c111d35fb7837c04509e3a27eba0a9af53ac7c"
    sha256 cellar: :any,                 sonoma:        "fe743ec07b0822631267242e83c572bbdbceb95dc12b991f0075b68fbba676cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f486c2cef08b8cc2e96b906608c22d77c4f22a3f302ffb1b31fecfaea85b53ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6c0b48fe9fe1f0239ff16864d3c1b28c5ff683a9d18cedfb27c28ee6c98ba61"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libpng"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    sse4 = Hardware::CPU.intel? && ((OS.mac? && MacOS.version.requires_sse4?) ||
                                    (!build.bottle? && Hardware::CPU.sse4?))

    args = %W[
      -DUSE_PYTHON=FALSE
      -DENABLE_LLVM_BACKEND=FALSE
      -DENABLE_QT5=FALSE
      -DENABLE_SSE4=#{sse4 ? "ON" : "OFF"}
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: share/"SeExpr2/utils")}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "doc"
    system "cmake", "--install", "build"
  end

  test do
    actual_output = shell_output("#{bin}/asciiGraph2 'x^3-8*x'").lines.map(&:rstrip).join("\n")
    roundoff = "#" if Hardware::CPU.arm? && (!OS.mac? || MacOS.version >= :ventura)
    expected_output = <<~EOS
                                    |        #
                              ##    |        #
                              ###   |
                             #  #   |        #
                             #  ##  |        #
                             #   #  |        #
                            ##   #  |        #
                            #    ## |        #
                            #     # |        #
                            #     # |        #
                            #     # |        #
                            #      #|       #
                           #       #|       #
                           #       #|       #
      ---------------------#-------##-------#---------------------
                           #        #       #
                           #        #       #
                           #        #       #
                           #        ##      #
                           #        |#     #
                          #         |#     #
                          #         |#     #
                          #         |##    #
                          #         | #    #
                          #         | #   #
                          #         | ##  #
                          #         |  #  #
                                    |  ####{roundoff}
                          #         |   ##
                          #         |
    EOS

    assert_equal expected_output.rstrip, actual_output
  end
end
