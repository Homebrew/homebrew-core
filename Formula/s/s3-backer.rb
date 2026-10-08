class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  # Release distributions listed at https://github.com/archiecobbs/s3backer/wiki/Downloads
  url "https://s3.amazonaws.com/archie-public/s3backer/s3backer-2.1.6.tar.gz"
  sha256 "55ff3123ab08d45822e6b349d9e305ca2ca13339474314cfc31a074d5308acf6"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_linux:  "56b20c0440559cb149a1c09c82665eecf0ae32c68658ce7f2218d998296d2074"
    sha256 cellar: :any, x86_64_linux: "76a55ed24c79463df4d088432c751ec341b29ff84c61a37af2fadad4501c326f"
  end

  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "expat"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@4"
  depends_on "zlib-ng-compat"
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
