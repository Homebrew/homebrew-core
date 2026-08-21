class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v7.8.4.tar.gz"
  sha256 "b16b3503e80890c78a5c845f8c141f239f3904359f1e41900ca566c86e120172"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "b0fdca4b3b6ec9ffa1c7251264a5b3997a5e4f0a620674a575e663de9e32d90c"
    sha256 arm64_sequoia: "10b994ff659858283e0e2909f11efbf5e489090dac41698b78861cb3a8342bfa"
    sha256 arm64_sonoma:  "5b2545f997793f9b936f05893f39042902a9a23c600f518b9058aade41b6e085"
    sha256 sonoma:        "297505e2062c80fb2a3a06c36eeab82840c946f1b4f13f42cacc437a5aeefa27"
    sha256 arm64_linux:   "37f1e4dbf6971a6b73aee56ce389a9759de535e016395ab41b2af5a5572cd804"
    sha256 x86_64_linux:  "f277ad0d497caa5993ccdb0c49eabe6913b62de019ba7895e6373339fb211750"
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
