class Snzip < Formula
  desc "Compression/decompression tool based on snappy"
  homepage "https://github.com/kubo/snzip"
  url "https://github.com/kubo/snzip/releases/download/v1.0.5/snzip-1.0.5.tar.gz"
  sha256 "fbb6b816619628f385b62f44a00a1603be157fba6ed2d30de490b0c5e645bff8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "128d2335e3d6cf3bd2189c851ab85d9031e141f1a7579dabcdd07a34925ef47f"
    sha256 cellar: :any,                 arm64_big_sur:  "77f41c9b756f8296621ba09b776da3afbdf396b29934a8ec8c5b3e4f7dd048eb"
    sha256 cellar: :any,                 monterey:       "867fa00a53ea2120f1ddadd12afeb6e882e2d556dd9d863071b812a2192f881f"
    sha256 cellar: :any,                 big_sur:        "5a096df1810d044eca22e485e7046cc58b1c4a8ccf966476fcdf213973a0accf"
    sha256 cellar: :any,                 catalina:       "1516b8b8808b7a76ace5a04d0d1b11edab13bd7cdb87d44f1831ca8dc203550c"
    sha256 cellar: :any,                 mojave:         "0304142d75d2495662ea2dae386948830aada6a7f653a90a74a746e56a7e9ff8"
    sha256 cellar: :any,                 high_sierra:    "fd4c734255707e1695f5d89a6dccc7d8b6a302771a71f6f6db0a054b9655d287"
    sha256 cellar: :any,                 sierra:         "953a79f0aa028d4b5f13cc606ead6e225c290972db683947dabed58bb6748257"
    sha256 cellar: :any,                 el_capitan:     "fdc031ce925717ee49048f3ffab3015f1039a06299f5093f7949e9a41cab975e"
    sha256 cellar: :any,                 yosemite:       "68247e4d0d0520d9a2615acd906d079951b84e4138b27a69c2aa7ce6a286dd9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c157aec2cfb6cfdf50f3573efbe3b20cb1de0a9f2ea4ebd53c84878e7f7966b"
  end

  depends_on "snappy"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.out").write "test"
    system "#{bin}/snzip", "test.out"
    system "#{bin}/snzip", "-d", "test.out.sz"
  end
end
