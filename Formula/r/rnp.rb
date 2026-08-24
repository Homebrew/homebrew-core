class Rnp < Formula
  desc "High performance C++ OpenPGP library used by Mozilla Thunderbird"
  homepage "https://www.rnpgp.org"
  url "https://github.com/rnpgp/rnp/releases/download/v0.18.1/rnp-v0.18.1.tar.gz"
  sha256 "423c8e32e1e591462f759adf8441b1c44bca96d9f5daff13b82e81a79f18ecfd"
  license all_of: ["MIT", "BSD-2-Clause", "BSD-3-Clause"]
  revision 3
  head "https://github.com/rnpgp/rnp.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3f2b6141a688892e9579a4c813ed4a7f312bf257d573b57925822e141b47e304"
    sha256 cellar: :any, arm64_sequoia: "3ff8644e0e279242192a466f881f164d9e0849b702a05b31dac8fc12fb093750"
    sha256 cellar: :any, arm64_sonoma:  "d57f8eebf6e8b2fd2ed952744cc758b60e129937c75990ddd28fd30a76884d5e"
    sha256 cellar: :any, sonoma:        "df6c649d0fc58be897ad9e4325c0f7e5eb38fb9cc6725004b2365d465ecbf3c8"
    sha256 cellar: :any, arm64_linux:   "e96f385a7824ea86841aa35b745d5b7780d849cc89265afa49a71ccdb43b8c76"
    sha256 cellar: :any, x86_64_linux:  "f772b9fdafa8fdd4caa31aab60ed6174064f8845f449bf10771a07d61572c970"
  end

  depends_on "cmake" => :build
  depends_on "botan"
  depends_on "json-c"
  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Backport upstream fix for the missing standard header with Botan 3.11
  patch do
    url "https://github.com/rnpgp/rnp/commit/29758631b5dde64b0059abe226c86c24ea08c3ce.patch?full_index=1"
    sha256 "f8903db07fd136c54932c088da92ef87e1c8091936c9301f416361d04c1d31e8"
    type :backport
    resolves "https://github.com/rnpgp/rnp/pull/2387"
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
