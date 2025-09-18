class Yajl < Formula
  desc "Yet Another JSON Library"
  homepage "https://lloyd.github.io/yajl/"
  url "https://github.com/lloyd/yajl/archive/refs/tags/2.1.0.tar.gz"
  sha256 "3fb73364a5a30efe615046d07e6db9d09fd2b41c763c5f7d3bfb121cd5c5ac5a"
  license "ISC"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_tahoe:    "ee1d81b4f6c8e21b07003ba2057aa1c0edc24acde0aea4f0570295227fb36ae6"
    sha256 cellar: :any,                 arm64_sequoia:  "dba63b344e3308d17991f4a71f5ac5dcdc12099cd1d64e1d32f2492a44562709"
    sha256 cellar: :any,                 arm64_sonoma:   "971639e642d5f2531ab6159ee96e86c159a9015fad89cc28eee10a3fc91eb9ef"
    sha256 cellar: :any,                 arm64_ventura:  "fe07a22a18a3172092b2b2163bceff50f423c142484f9a62687dcf2a8ee6e330"
    sha256 cellar: :any,                 arm64_monterey: "95735cd614157ed2756dac69c80d81b83d305f0dcb54c3299c00e5f0528ddd0e"
    sha256 cellar: :any,                 arm64_big_sur:  "baefc7dc955217c4bdefd8dc798a6ad432131f449370a6249e31be6604842942"
    sha256 cellar: :any,                 sonoma:         "d3669145f9a916ca3c1ec00e787e2bfb9be62f822d69f7cac414355692406d5b"
    sha256 cellar: :any,                 ventura:        "9a161cb8262cbcfabcd1559498d22ab1a5ba80f037a00149efbcbd88305ba91b"
    sha256 cellar: :any,                 monterey:       "af69d2c0088d874cbd0fa3fb534fb971943c81a8e49574758d8bfcfa4504ca5c"
    sha256 cellar: :any,                 big_sur:        "18bd8c54e847441959876cc9580db5ddcb7e3b92f2fc37ca49ce27d17c050df3"
    sha256 cellar: :any,                 catalina:       "65975afbeddbbd919282c04e53fccda191501eb4fa8992a2b4ab1b2be2e10151"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8b1df8e59b01fee163b184e36bf7f607c8ff83be33f94361f9bdf67ce5b8e636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c206281370fe7277f21d17ff50fe9511233aff74501238516918027006c9cbf3"
  end

  depends_on "cmake" => :build

  # Workaround to build with CMake 4
  patch do
    url "https://github.com/lloyd/yajl/commit/6fe59ca50dfd65bdb3d1c87a27245b2dd1a072f9.patch?full_index=1"
    sha256 "b059e4181aca7c50c71924632b5e1dc263ea05a2e7fc6def095c0cc65398282c"
  end

  def install
    ENV.deparallelize

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (include/"yajl").install Dir["src/api/*.h"]
  end

  test do
    output = pipe_output("#{bin}/json_verify", "[0,1,2,3]").strip
    assert_equal "JSON is valid", output
  end
end
