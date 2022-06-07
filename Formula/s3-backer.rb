class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://github.com/archiecobbs/s3backer/archive/refs/tags/2.0.1.tar.gz"
  sha256 "16fa56e9d126abf56f9ba610a5e8d487f95907bdd937b00610ff3f4b5ce11153"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "055a37d8f9b6dceeeca5798a68fa931526e1c10144fa0201adf0d02188aaa465"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"
  uses_from_macos "expat"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse@2"
  end

  def install
    system "./autogen.sh"
    inreplace "configure", "-lfuse", "-losxfuse" if OS.mac?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
      EOS
    end
  end

  test do
    system bin/"s3backer", "--version"
  end
end
