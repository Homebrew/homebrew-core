class Txikijs < Formula
  desc "Small and powerful JavaScript runtime"
  homepage "https://github.com/saghul/txiki.js"
  url "https://github.com/saghul/txiki.js.git",
      tag:      "v24.12.0",
      revision: "793dd9d8bb1d54726ca4e7af1d951418e199175f"
  license "MIT"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "texinfo" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/tjs"
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/tjs --version").chomp
    assert_match "Hello, world!", shell_output("#{bin}/tjs eval \"console.log('Hello, world!')\"")
  end
end
