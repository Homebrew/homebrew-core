class Rnp < Formula
  desc "High performance C++ OpenPGP library used by Mozilla Thunderbird"
  homepage "https://github.com/rnpgp/rnp"
  url "https://github.com/rnpgp/rnp/releases/download/v0.18.1/rnp-v0.18.1.tar.gz"
  sha256 "423c8e32e1e591462f759adf8441b1c44bca96d9f5daff13b82e81a79f18ecfd"
  license all_of: ["MIT", "BSD-2-Clause", "BSD-3-Clause"]
  revision 2
  head "https://github.com/rnpgp/rnp.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2344ff5adbe5d72f6fcaa4af8574f9ce6f6b02e7b54df3ecf9ba4e23697b8c89"
    sha256 cellar: :any,                 arm64_sequoia: "58d9d80414285a3b93d0ddb9865be9f7baf17ac9c1474352fac8ac8ce920a1f6"
    sha256 cellar: :any,                 arm64_sonoma:  "d3bcb8d5c877cf78cf1c0ede7c9964fc1194a0356d24309e113f223f51e6a0a6"
    sha256 cellar: :any,                 sonoma:        "e426722984650a0186e274682f77190342bd424b1fa1c9479c8b61a26bc09307"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b6fe3df69d2b4c54ecab9e5cb303cfad0be704369d6a27c9899b69a122e8894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9c4641dd31cae1cfb1b7738fecac8d266129e644c33b04a51069f67176c7155"
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
