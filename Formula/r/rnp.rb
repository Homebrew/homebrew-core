class Rnp < Formula
  desc "High performance C++ OpenPGP library used by Mozilla Thunderbird"
  homepage "https://github.com/rnpgp/rnp"
  url "https://github.com/rnpgp/rnp/releases/download/v0.18.0/rnp-v0.18.0.tar.gz"
  sha256 "a90e3ac5b185a149665147f9284c0201a78431e81924883899244522fd3f9240"
  license all_of: ["MIT", "BSD-2-Clause", "BSD-3-Clause"]
  revision 1
  head "https://github.com/rnpgp/rnp.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5bc131fa488e241c842a559ef99f1af00a02860c0c50cf578aa6ae63a9e39c62"
    sha256 cellar: :any,                 arm64_sequoia: "c0863e62cfd19c4ed109c9332159b17f7ae23217045b501d61d6ccf76f6992d0"
    sha256 cellar: :any,                 arm64_sonoma:  "50710472292623c87a9b3be1ff88f51c2b95f466854461e3a6b297eb1bc1ce27"
    sha256 cellar: :any,                 arm64_ventura: "d63ed87e2cd63d7bb147a563508a3e7538ef9bc9a0257a500b133d67deef2aea"
    sha256 cellar: :any,                 sonoma:        "af41bf6b0e21af8d9c40258447518aa2f8aa1ab6c7cd338961441c2c605b6cb3"
    sha256 cellar: :any,                 ventura:       "531575b35f6da98ff16ebf4482c3f5e6ebcedd7a81a1df7881db49c85da2e204"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e4c0c648c3e7a1c427fef882e2458f6615e19c64f796886d7dacd29194550be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7eac4eb4fd83b477a733f074a0e7b1ad605a67d0957e8d186e70fbb296d2bd3"
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
