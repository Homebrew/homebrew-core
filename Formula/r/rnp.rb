class Rnp < Formula
  desc "High performance C++ OpenPGP library used by Mozilla Thunderbird"
  homepage "https://github.com/rnpgp/rnp"
  url "https://github.com/rnpgp/rnp/releases/download/v0.18.1/rnp-v0.18.1.tar.gz"
  sha256 "423c8e32e1e591462f759adf8441b1c44bca96d9f5daff13b82e81a79f18ecfd"
  license all_of: ["MIT", "BSD-2-Clause", "BSD-3-Clause"]
  revision 1
  head "https://github.com/rnpgp/rnp.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "47196b99e7ce95c4321785266f05084c18f935efcab165b7d78612c6556c6332"
    sha256 cellar: :any,                 arm64_sequoia: "fc1b11f0ac1e476f6fbe0f19637b1a301f0090455148bb2441f0add820a0a548"
    sha256 cellar: :any,                 arm64_sonoma:  "7b942b2d37b54d5252440ba931502a312c676c35b5ed52b6452464687162693b"
    sha256 cellar: :any,                 sonoma:        "dc917f41e573c19a3255a8649f24957bbd8717dcd80417ee475214da896e5505"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64ebe0a2a1390be568fbe20ae76808f1853353af20cf2f63b3687c93b152a8c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bdd2d6cae58daf0287d95bbc2ef321976091e628fcfba2b9eff2356e13109a9"
  end

  depends_on "cmake" => :build
  depends_on "botan"
  depends_on "json-c"
  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Backport upstream fix for the missing standard header with Botan 3.11. upstream pr ref, https://github.com/rnpgp/rnp/pull/2382
  patch do
    url "https://github.com/chenrui333/rnp/commit/29758631b5dde64b0059abe226c86c24ea08c3ce.patch?full_index=1"
    sha256 "f8903db07fd136c54932c088da92ef87e1c8091936c9301f416361d04c1d31e8"
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
