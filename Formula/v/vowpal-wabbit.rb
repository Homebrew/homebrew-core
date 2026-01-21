class VowpalWabbit < Formula
  desc "Online learning algorithm"
  homepage "https://github.com/VowpalWabbit/vowpal_wabbit"
  url "https://github.com/VowpalWabbit/vowpal_wabbit/archive/refs/tags/9.10.0.tar.gz"
  sha256 "9f4ec5cddf67af2c7aa9b380b23fe22c4b11e2109f2cbaa1314bdf3570749a4d"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/VowpalWabbit/vowpal_wabbit.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cf06a7d71afc411b70a5180e3c7f17174800c21eb984ca552523d05e1d48dc8d"
    sha256 cellar: :any,                 arm64_sequoia: "dcf23c662a2ae94c97abfe2756a3b7b545fee913148f471aa4706c0bdb97c27d"
    sha256 cellar: :any,                 arm64_sonoma:  "315dbd71b2ae7c0a4a7d04e69616de5b9efadc6684dfa6450be6ad4a4ba8bb7d"
    sha256 cellar: :any,                 sonoma:        "35f2af451771f6153f139aea0cea8e6afa495b4cb33f4c9b4d52f3de887e2c7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92f674e4035f4e003784b4942809934d3b7e82801e33c4e98484eda70952ede3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83f19ae77085270dab292a53fa72203559c6b0782010cb55846a8c9e09c43283"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "rapidjson" => :build
  depends_on "spdlog" => :build
  depends_on "fmt"

  uses_from_macos "zlib"

  on_arm do
    depends_on "sse2neon" => :build
  end

  # Reported at https://github.com/VowpalWabbit/vowpal_wabbit/issues/4700
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/vowpal-wabbit/fmt11.diff"
    sha256 "15f6f9013715bd1dc33456394b3f464aed863ef726479bb272a2f92db2ee7ea0"
  end

  # Apply open PR to support eigen 5.0.0
  # PR ref: https://github.com/VowpalWabbit/vowpal_wabbit/pull/4720
  patch do
    url "https://github.com/VowpalWabbit/vowpal_wabbit/commit/1c8a86786f415d44a001e64ba823c5f3e80f48a0.patch?full_index=1"
    sha256 "035973d7b49ac3cf266700c4777950b2b0ded095114873110b75467bfe3c2199"
  end

  def install
    args = %w[
      -DRAPIDJSON_SYS_DEP=ON
      -DFMT_SYS_DEP=ON
      -DSPDLOG_SYS_DEP=ON
      -DVW_BOOST_MATH_SYS_DEP=ON
      -DVW_EIGEN_SYS_DEP=ON
      -DVW_SSE2NEON_SYS_DEP=ON
      -DVW_INSTALL=ON
      -DVW_CXX_STANDARD=14
    ]

    # The project provides a Makefile, but it is a basic wrapper around cmake
    # that does not accept *std_cmake_args.
    # The following should be equivalent, while supporting Homebrew's standard args.
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
