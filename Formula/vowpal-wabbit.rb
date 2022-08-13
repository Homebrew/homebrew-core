class VowpalWabbit < Formula
  desc "Online learning algorithm"
  homepage "https://github.com/VowpalWabbit/vowpal_wabbit"
  url "https://github.com/VowpalWabbit/vowpal_wabbit/archive/9.3.0.tar.gz"
  sha256 "e7ffda2782bb2f0bdf8235db3e9655c71e005d762cab0fa19d260fe672c6104b"
  license "BSD-3-Clause"
  head "https://github.com/VowpalWabbit/vowpal_wabbit.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "566bbc0d0b90b38ce598e8472aae50e8b453f31f68068e203744c3ca00a8dd11"
    sha256 cellar: :any,                 arm64_big_sur:  "5142c9b8fa6178ce7dbb7ec2c4b38bc9344d9023a82a3fbf4d2302808f4bf244"
    sha256 cellar: :any,                 monterey:       "239f5fa734a6a20fb1f7330603922fda9a4a1bde4e8a0d744c8abc0eed4abc44"
    sha256 cellar: :any,                 big_sur:        "1986d0ce20d9a2eba429c9a05ff15d33d0c2e7c62d9f4f6e49c0964bc05a5996"
    sha256 cellar: :any,                 catalina:       "4045c53043055511c6f5931e203f70f4136ff426a4fb1583b5a12cbe0906b577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e19d3d49947bdeba5e1658817f1d81208994e6b1c0e00dc9c643d7a4eed778b"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "spdlog" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "fmt"
  uses_from_macos "zlib"

  def install
    ENV.cxx11
    # The project provides a Makefile, but it is a basic wrapper around cmake
    # that does not accept *std_cmake_args.
    # The following should be equivalent, while supporting Homebrew's standard args.
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DBUILD_TESTING=OFF",
                            "-DRAPIDJSON_SYS_DEP=ON",
                            "-DFMT_SYS_DEP=ON",
                            "-DSPDLOG_SYS_DEP=ON",
                            "-DVW_BOOST_MATH_SYS_DEP=On",
                            "-DVW_INSTALL=On"
      system "make", "install"
    end
    bin.install Dir["utl/*"]
    rm bin/"active_interactor.py"
    rm bin/"vw-validate.html"
    rm bin/"clang-format.sh"
    rm bin/"release_blog_post_template.md"
    rm_r bin/"flatbuffer"
    rm_r bin/"dump_options"
  end

  test do
    (testpath/"house_dataset").write <<~EOS
      0 | price:.23 sqft:.25 age:.05 2006
      1 2 'second_house | price:.18 sqft:.15 age:.35 1976
      0 1 0.5 'third_house | price:.53 sqft:.32 age:.87 1924
    EOS
    system bin/"vw", "house_dataset", "-l", "10", "-c", "--passes", "25", "--holdout_off",
                     "--audit", "-f", "house.model", "--nn", "5"
    system bin/"vw", "-t", "-i", "house.model", "-d", "house_dataset", "-p", "house.predict"

    (testpath/"csoaa.dat").write <<~EOS
      1:1.0 a1_expect_1| a
      2:1.0 b1_expect_2| b
      3:1.0 c1_expect_3| c
      1:2.0 2:1.0 ab1_expect_2| a b
      2:1.0 3:3.0 bc1_expect_2| b c
      1:3.0 3:1.0 ac1_expect_3| a c
      2:3.0 d1_expect_2| d
    EOS
    system bin/"vw", "--csoaa", "3", "csoaa.dat", "-f", "csoaa.model"
    system bin/"vw", "-t", "-i", "csoaa.model", "-d", "csoaa.dat", "-p", "csoaa.predict"

    (testpath/"ect.dat").write <<~EOS
      1 ex1| a
      2 ex2| a b
      3 ex3| c d e
      2 ex4| b a
      1 ex5| f g
    EOS
    system bin/"vw", "--ect", "3", "-d", "ect.dat", "-f", "ect.model"
    system bin/"vw", "-t", "-i", "ect.model", "-d", "ect.dat", "-p", "ect.predict"

    (testpath/"train.dat").write <<~EOS
      1:2:0.4 | a c
        3:0.5:0.2 | b d
        4:1.2:0.5 | a b c
        2:1:0.3 | b c
        3:1.5:0.7 | a d
    EOS
    (testpath/"test.dat").write <<~EOS
      1:2 3:5 4:1:0.6 | a c d
      1:0.5 2:1:0.4 3:2 4:1.5 | c d
    EOS
    system bin/"vw", "-d", "train.dat", "--cb", "4", "-f", "cb.model"
    system bin/"vw", "-t", "-i", "cb.model", "-d", "test.dat", "-p", "cb.predict"
  end
end
