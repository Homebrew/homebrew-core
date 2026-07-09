class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v7.8.2.tar.gz"
  sha256 "f991cc6c61dbc5af5a3b3939083e917df4113509549670fb400d121f639f69f6"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "5ae957c9d423696fac8fe0faffd8bb5c5792c9a6ebe2f3c158ed43e2fd7253f0"
    sha256 arm64_sequoia: "884359947524bb8b9e64166bc29394a0250827662e43b7258ded58257aceda4c"
    sha256 arm64_sonoma:  "37d756834e85d8b8d9d202689073f32256c7161129a8837b55540e9cf817f99a"
    sha256 sonoma:        "0de4e875bcadc25509dd730d63e8a55b7ce75836a977d58364986ae10b6b1805"
    sha256 arm64_linux:   "015d45738e852bae06005ff1634d2b74fc8f55094611ec190097ec8daa5b66eb"
    sha256 x86_64_linux:  "ba819e243a46d18151a43a39a667e82b8f733c79b88e5a70a016c0003c0a1cf9"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
