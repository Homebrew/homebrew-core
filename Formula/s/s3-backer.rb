class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  # Release distributions listed at https://github.com/archiecobbs/s3backer/wiki/Downloads
  url "https://s3.amazonaws.com/archie-public/s3backer/s3backer-2.1.1.tar.gz"
  sha256 "9ad359d6ad1fa9d3161232872247966740e9ed4ff085e07ddab1b4ca52279f65"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "99ad1e019e8cd0a7c11604e77c44724081271bf50afbe93f1a218162d3aae12b"
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
