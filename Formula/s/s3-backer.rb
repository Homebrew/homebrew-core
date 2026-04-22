class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  # Release distributions listed at https://github.com/archiecobbs/s3backer/wiki/Downloads
  url "https://s3.amazonaws.com/archie-public/s3backer/s3backer-2.1.6.tar.gz"
  sha256 "55ff3123ab08d45822e6b349d9e305ca2ca13339474314cfc31a074d5308acf6"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "0f3a5bfb9e813f0a54c775a8f7b0b533a17d9d193646e78f27e999f366d63f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1387d7e202fc1f4dce4b895dae49a9073f9020155ed87f65d5f7fb907117ab15"
  end

  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "expat"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"
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
