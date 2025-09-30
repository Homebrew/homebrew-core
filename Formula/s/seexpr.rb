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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "0fd5628f6fdb5836a1dac4449b9d676a31ef446d1e7f7f991a62c09e56029d2c"
    sha256 cellar: :any,                 arm64_sequoia: "bb4a0dda70f5ddd52570aa14998475ca6a14a02e57c0703084d32b25fee3b69d"
    sha256 cellar: :any,                 arm64_sonoma:  "1b5ce1a0a308b584bd43837a5cc06fa4d1c88276bec2b1a510088a96d947033f"
    sha256 cellar: :any,                 arm64_ventura: "48d883728af997e5d3805c2b162973aa5d883b38db75ce2caeb5174406276713"
    sha256 cellar: :any,                 sonoma:        "e4c95048b7bef18faee54008b94f674863f18b42fd1fa6bc978c6c96a0167791"
    sha256 cellar: :any,                 ventura:       "1634179b0990f9b55997ea81ff5a9b8702cb4d8fdaaa3f3ef64d34b5ccb45bfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc21c3bcac5847ffdfab83c45e85312726b9bc0bc4f6af7b3a1457b85e2baa97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb306407c4c3dceac93d89e8505a81bde4b4a20798f2e856bf7189ae41dc77ea"
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
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DUSE_PYTHON=FALSE
      -DENABLE_LLVM_BACKEND=FALSE
      -DENABLE_QT5=FALSE
      -DENABLE_SSE4=#{sse4 ? "ON" : "OFF"}
    ]

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
