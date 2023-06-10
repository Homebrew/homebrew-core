class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs.git",
      tag:      "0.14.1",
      revision: "4a57f0342d1f0f71f6b8833abf4a6bafc0e6c187"
  license "MIT"
  head "https://github.com/netheril96/securefs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4ee41830ddaa8bae8ad280a3826e28895d6ee21e487fc7fa6cbf8f8d5835c8e6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "argon2"
  depends_on "jsoncpp"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "utf8proc"

  def install
    args = std_cmake_args + %w[
      -DSECUREFS_ENABLE_BUILD_TEST=OFF
      -DSECUREFS_USE_VCPKG=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/securefs", "version" # The sandbox prevents a more thorough test
  end
end
