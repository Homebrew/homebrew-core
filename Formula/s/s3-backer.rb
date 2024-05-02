class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  # Release distributions listed at https://github.com/archiecobbs/s3backer/wiki/Downloads
  url "https://s3.amazonaws.com/archie-public/s3backer/s3backer-2.1.2.tar.gz"
  sha256 "ab0be273a4b3ce2d74ed3d554a045a4c1d1b2b6c7eb042e0eca7b4e4372dbbb8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "716c3eee156c8fb61fffab4e13148acd2c1924515f5b4defc3a39c2555d6538b"
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
