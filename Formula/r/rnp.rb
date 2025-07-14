class Rnp < Formula
  desc "High performance C++ OpenPGP library used by Mozilla Thunderbird"
  homepage "https://github.com/rnpgp/rnp"
  url "https://github.com/rnpgp/rnp/releases/download/v0.18.0/rnp-v0.18.0.tar.gz"
  sha256 "a90e3ac5b185a149665147f9284c0201a78431e81924883899244522fd3f9240"
  license all_of: ["MIT", "BSD-2-Clause", "BSD-3-Clause"]
  head "https://github.com/rnpgp/rnp.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f32421017f5d7b8cbe686b773d77f7c489fc745aa187feb587b603a65a971eb"
    sha256 cellar: :any,                 arm64_sonoma:  "63ad3905d1286594f3f98de8343474a660929974cd25caa0ebe4e9af505b5e41"
    sha256 cellar: :any,                 arm64_ventura: "1793864c5ac801908df2c185aaa75fdf1ec78b589f4d686a50fbc94f6ac2e357"
    sha256 cellar: :any,                 sonoma:        "6bbb2952df99c6b04c3cbc4c4465e6ce0eeebdebde37fe971d55f2f782b7b58b"
    sha256 cellar: :any,                 ventura:       "b1045aedf6befd06a9fc6c2399282298b74d034eb4d01b09eef31bcb94be6dda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f35c057bf0560cd0621089236490d8f2e1019cddbe6147b37c75324a82a93b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "426c2a6c95992b27f8b08631049fac856888caf66ef7bfd6d5c2afd50c9f98a8"
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
