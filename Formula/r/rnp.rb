class Rnp < Formula
  desc "High performance C++ OpenPGP library used by Mozilla Thunderbird"
  homepage "https://github.com/rnpgp/rnp"
  url "https://github.com/rnpgp/rnp/releases/download/v0.18.1/rnp-v0.18.1.tar.gz"
  sha256 "423c8e32e1e591462f759adf8441b1c44bca96d9f5daff13b82e81a79f18ecfd"
  license all_of: ["MIT", "BSD-2-Clause", "BSD-3-Clause"]
  head "https://github.com/rnpgp/rnp.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6a2ecfe7414873e058469fd0220f05572a35b83a62cf22d9f12cf58c26d79fc7"
    sha256 cellar: :any,                 arm64_sequoia: "fe20273522197c6d524ef75674cfad1f8814868d5cb445c183d01be6dbfbabfa"
    sha256 cellar: :any,                 arm64_sonoma:  "245324c4b41228123aff0f791cb317652cc658773fbcea4159ceb2c24265a6b3"
    sha256 cellar: :any,                 sonoma:        "c74ab53d956170a5c321b3eeb984c4e100ce15c995e0f606de5bcab0b5fcd060"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82d8e226eb32638112fde260c44d95cebe551190e30bd50b69f416d43b4b2cd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "561a320aae32d97588869ea843fdec9cac8c18eb00201293f69c5db30263bfcd"
  end

  depends_on "cmake" => :build
  depends_on "botan"
  depends_on "json-c"
  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"message.txt").write "hello"
    encr = testpath/"enc.rnp"
    decr = testpath/"dec.rnp"

    system bin/"rnpkeys", "--generate-key", "--password=PASSWORD"
    system bin/"rnp", "-c", "--password", "DUMMY", "--output", encr, "message.txt"
    system bin/"rnp", "--decrypt", "--password", "DUMMY", "--output", decr, encr

    assert_equal "hello", decr.read
  end
end
