class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  # Release distributions listed at https://github.com/archiecobbs/s3backer/wiki/Downloads
  url "https://s3.amazonaws.com/archie-public/s3backer/s3backer-2.1.6.tar.gz"
  sha256 "55ff3123ab08d45822e6b349d9e305ca2ca13339474314cfc31a074d5308acf6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c51051aaf9df0f18656f3a18e18be9fcd8b52387df778040b4c68d5802c33bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7949743c2405f21633a2c533b27a1cf3561c652f4714e147b9965a086b0f5861"
  end

  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "expat"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"
  depends_on "zlib"
  depends_on "zstd"

  def install
    system "./configure", "--disable-silent-rules",
            *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/s3backer --version 2>&1")

    assert_match "no S3 bucket specified", shell_output("#{bin}/s3backer 2>&1", 1)
  end
end
