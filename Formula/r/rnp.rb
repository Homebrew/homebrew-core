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
    sha256 cellar: :any,                 arm64_tahoe:   "8f190c867fe3cd8c3d0b84f20952bfb285a53cda7cdf6336b0c6ad31869a12b2"
    sha256 cellar: :any,                 arm64_sequoia: "d68ff5a9c1adccacd1c5cebe16c82d480241731a7de389155dcb5ca19ee4868b"
    sha256 cellar: :any,                 arm64_sonoma:  "e9091cef22ec6032cfe05f5e3001ee59e940f4c86da85785fe822feb1c81b86c"
    sha256 cellar: :any,                 sonoma:        "9e01532ff416c56e67487de414d1aa63a40fff591a4b08bdc91da43edb9103fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e69e17ff598efdd28cf3880559fd999cef9ff702c655fae14c52c93c1f9020f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e48671491ac5bae9fb7971d448eb04399b8a46314ca87aa8ce2ec958dc54434c"
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
