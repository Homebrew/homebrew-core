class VowpalWabbit < Formula
  desc "Online learning algorithm"
  homepage "https://github.com/VowpalWabbit/vowpal_wabbit"
  url "https://github.com/VowpalWabbit/vowpal_wabbit/archive/9.5.0.tar.gz"
  sha256 "20820d0f399df999d8177170705a93f4f06ce141fc2220fd76a591e45dc75925"
  license "BSD-3-Clause"
  head "https://github.com/VowpalWabbit/vowpal_wabbit.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6e37f3dab7e5823072d334cfd88a191f74aebd5cdcb1784aab6892b0d1898006"
    sha256 cellar: :any,                 arm64_big_sur:  "b945a087413ccb26d0132853e44c528c5c22521143ca8bbef31930ae9328fcac"
    sha256 cellar: :any,                 monterey:       "bfddf9c006f8a4932cc8fb03923cc41597b01e35f1d5c9503510952f89089a8a"
    sha256 cellar: :any,                 big_sur:        "426363038d9d779dd22fc2d5681f42ae74f9971f80a9b1debb1de5134cf94856"
    sha256 cellar: :any,                 catalina:       "eaecfad715c5de72e77443a439e1f573b64bfba8176bb0fd5d90c8005e2584a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b30b9c7c8b00398ad5df59109692864c64e62f214cc11ab392631fde13f056a"
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
