class Rnp < Formula
  desc "High performance C++ OpenPGP library used by Mozilla Thunderbird"
  homepage "https://github.com/rnpgp/rnp"
  url "https://github.com/rnpgp/rnp/releases/download/v0.18.0/rnp-v0.18.0.tar.gz"
  sha256 "a90e3ac5b185a149665147f9284c0201a78431e81924883899244522fd3f9240"
  license all_of: ["MIT", "BSD-2-Clause", "BSD-3-Clause"]
  revision 2
  head "https://github.com/rnpgp/rnp.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1bd7e9485c9b0ea2aa7c6d787eddae43b1fa99d11d8e5626f9199457eac31d49"
    sha256 cellar: :any,                 arm64_sequoia: "747467a9855d3235028bac5b0ad50e5ad82526d33a3c51eec2d1c274da06e636"
    sha256 cellar: :any,                 arm64_sonoma:  "ac081ab0a5b46a25feab56660944e1a39467e620f74e7e66409b43a1777a6848"
    sha256 cellar: :any,                 sonoma:        "959d0d675313ea0d9a67e0f0d0b7885e90b41494ecd4f87a0d261e1977f8091c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83e9ca9151e174cd4efecebfdddf29215895a3af79ebfecb1acb9be2d43d94c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74cd62eb2b625bd930518c0bdc7b9b8fce3101dd7ac96580441408382ae1576e"
  end
  depends_on "cmake" => :build
  depends_on "botan"
  depends_on "json-c"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
