class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  # Release distributions listed at https://github.com/archiecobbs/s3backer/wiki/Downloads
  url "https://s3.amazonaws.com/archie-public/s3backer/s3backer-2.0.2.tar.gz"
  sha256 "0b2432f08e9b986364e35674f39dd11afc1670be382b23cdb7375e86ce132a02"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5c8f5e8a937e4838c0bada7dcbd98727e6e9d73d5558652b75d0a7a1b8657b0c"
  end

  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on "expat"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@1.1"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"s3backer", "--version"
  end
end
