class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://archie-public.s3.amazonaws.com/s3backer/s3backer-1.5.6.tar.gz"
  sha256 "deea48205347b24d1298fa16bf3252d9348d0fe81dde9cb20f40071b8de60519"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, catalina:    "f54a33c549b57b056808803b4cc722596a89bb9413d135161952903de975a3f5"
    sha256 cellar: :any, mojave:      "346fe1b085490959e17acf9930878b46b8224bf20b7aada21a1a48ab963c0da3"
    sha256 cellar: :any, high_sierra: "4d23cfd2c126c5f3efa1023e7c061830de6f1fdda69760bbd3ed70a169def288"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    inreplace "configure", "-lfuse", "-losxfuse"
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
