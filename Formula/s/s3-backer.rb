class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  # Release distributions listed at https://github.com/archiecobbs/s3backer/wiki/Downloads
  url "https://s3.amazonaws.com/archie-public/s3backer/s3backer-2.1.3.tar.gz"
  sha256 "b49a7cae66bc29e8104db889e7e63137748d4a3442d88ebad9fffa4705808a81"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "60886e9f4d464c3050a711c732717fc833fa1364b60acbe1f07a15e2d13e8728"
  end

  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on "expat"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"s3backer", "--version"
  end
end
