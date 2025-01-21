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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "d568f50ded114a9116f96515049ba0938ab9d348e6254c649412426edb7a6909"
    sha256 cellar: :any,                 arm64_sonoma:   "5da5b2e705b2aa90b55a91e3671c07bbad530694de37ad57d6be0441bcd4421f"
    sha256 cellar: :any,                 arm64_ventura:  "b28dd49e3d0b93c67e39ed97067547643b9254119e9bc117b575739fda21ba9d"
    sha256 cellar: :any,                 arm64_monterey: "164fa646ad87a1c238d9581a59f6d4cc2992aff2a70cb1c2467cd20eaea02823"
    sha256 cellar: :any,                 sonoma:         "f996afede28403cf87f1cab3ce3d689358dc0f588cb056cea633beddc5e7b26d"
    sha256 cellar: :any,                 ventura:        "ff14944ca49cfb596a51a60e99b4af150869d58ff50f4e696144dbc2f329198e"
    sha256 cellar: :any,                 monterey:       "015e7bfe379958ce3e7cf76160b7db986bb3b64b352d9d7d7264408efacd5b3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e1e13ab5faa794301571ff544a072b4cc4398affe0f61113ff13918025e3680"
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
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DUSE_PYTHON=FALSE
      -DENABLE_LLVM_BACKEND=FALSE
      -DENABLE_QT5=FALSE
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "doc"
    system "cmake", "--install", "build"
  end

  test do
    actual_output = shell_output("#{bin}/asciiGraph2 'x^3-8*x'").lines.map(&:rstrip).join("\n")
    roundoff = "#" if Hardware::CPU.arm? && OS.mac? && MacOS.version >= :ventura
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

    assert_equal actual_output, expected_output.rstrip
  end
end
