class Rnp < Formula
  desc "High performance C++ OpenPGP library used by Mozilla Thunderbird"
  homepage "https://www.rnpgp.org"
  url "https://github.com/rnpgp/rnp/releases/download/v0.18.1/rnp-v0.18.1.tar.gz"
  sha256 "423c8e32e1e591462f759adf8441b1c44bca96d9f5daff13b82e81a79f18ecfd"
  license all_of: ["MIT", "BSD-2-Clause", "BSD-3-Clause"]
  revision 4
  head "https://github.com/rnpgp/rnp.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "daafa7c464a3339103e4643094028c08a9a6443a21bd0887d64da2d656e5094d"
    sha256 cellar: :any, arm64_tahoe:       "4964361b5ed77d10a016384d47afbfee1e2e7542221346c6584689ac693a7266"
    sha256 cellar: :any, arm64_sequoia:     "3fab1d7a26b52b094c17977ca50cc3961ab725ad281488a0250adbe4b3da2c4e"
    sha256 cellar: :any, arm64_linux:       "75be327927324dd1cf42f2afcab1109fdae77691a8f85d272b11b0867cf94a87"
    sha256 cellar: :any, x86_64_linux:      "118f0e30273e9a3d157d4faa295a7d8529a9d6c0dfb4aff72569584548843326"
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

  deny_network_access!

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
