class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  # Release distributions listed at https://github.com/archiecobbs/s3backer/wiki/Downloads
  url "https://s3.amazonaws.com/archie-public/s3backer/s3backer-2.0.2.tar.gz"
  sha256 "0b2432f08e9b986364e35674f39dd11afc1670be382b23cdb7375e86ce132a02"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c68f51b178923e9e4327bd91711ad5c058e8d99ad619c769ddefc2be2cc338b8"
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
