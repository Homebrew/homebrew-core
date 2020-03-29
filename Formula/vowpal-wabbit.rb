class VowpalWabbit < Formula
  desc "Online learning algorithm"
  homepage "https://github.com/VowpalWabbit/vowpal_wabbit"
  # pull from git tag to get submodules
  url "https://github.com/VowpalWabbit/vowpal_wabbit.git",
    :tag      => "8.8.1",
    :revision => "5ff219ec0ff28af5d35e452f5f18e6808993e08a"
  revision 1
  head "https://github.com/VowpalWabbit/vowpal_wabbit.git"

  bottle do
    cellar :any
    sha256 "67b1a1ff72db3a4fb3a8feecf372999b09a9c0eb429d449fe3038aaf1c866a52" => :catalina
    sha256 "420d53c0004628986811ad2c7e0b83fd20bad1db5bac9b8775e40daf788b0a9b" => :mojave
    sha256 "ff5920ae1294c66d9b4752326818d4b9aa88f6ecfdffbd740691f13b99b4e6e7" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "boost"

  # Support using brewed rapidjson
  patch do
    url "https://github.com/VowpalWabbit/vowpal_wabbit/commit/9aea63874e70eee477b9b281ef12515f70f5d1bd.patch?full_index=1"
    sha256 "e69037901f0027dbcd21204822875efb98c676805d383818483fbe7badc3d6b4"
  end

  def install
    ENV.cxx11
    # The project provides a Makefile, but it is a basic wrapper around cmake
    # that does not accept *std_cmake_args.
    # The following should be equivalent, while supporting Homebrew's standard args.
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DBUILD_TESTS=OFF",
                            "-DRAPIDJSON_SYS_DEP=ON"
      system "make", "install"
    end
    bin.install Dir["utl/*"]
    rm bin/"active_interactor.py"
    rm bin/"new_version"
    rm bin/"vw-validate.html"
    rm bin/"clang-format"
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
