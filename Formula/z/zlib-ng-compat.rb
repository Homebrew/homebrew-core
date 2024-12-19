class ZlibNgCompat < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.2.2.tar.gz"
  sha256 "fcb41dd59a3f17002aeb1bb21f04696c9b721404890bb945c5ab39d2cb69654c"
  license "Zlib"
  head "https://github.com/zlib-ng/zlib-ng.git", branch: "develop"

  livecheck do
    formula "zlib-ng"
  end

  keg_only :shadowed_by_macos, "macOS provides zlib"

  on_linux do
    keg_only "it conflicts with zlib"
  end

  # https://zlib.net/zlib_how.html
  resource "homebrew-test_artifact" do
    url "https://zlib.net/zpipe.c"
    version "20051211"
    sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
  end

  def install
    ENV.runtime_cpu_detection
    # Disabling new strategies based on Fedora comment on keeping compatibility with zlib
    # Ref: https://src.fedoraproject.org/rpms/zlib-ng/blob/rawhide/f/zlib-ng.spec#_120
    system "./configure", "--prefix=#{prefix}", "--without-new-strategies", "--zlib-compat"
    system "make", "install"
  end

  test do
    testpath.install resource("homebrew-test_artifact")
    system ENV.cc, "zpipe.c", "-I#{include}", lib/shared_library("libz"), "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text)
    assert_equal text, pipe_output("./zpipe -d", compressed)
  end
end
