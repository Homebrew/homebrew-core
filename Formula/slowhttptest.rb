class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://github.com/shekyan/slowhttptest/archive/v1.9.0.tar.gz"
  sha256 "a3910b9b844e05ee55838aa17beddc6aa9d6c5c0012eab647a21cc9ccd6c8749"
  license "Apache-2.0"
  head "https://github.com/shekyan/slowhttptest.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e84609014884866c736a1b5e5fe55076d7c19f2fc5b952c8c9abd2b4155d9a6f"
    sha256 cellar: :any,                 arm64_big_sur:  "d546effe0b167b84201c0fcd21e2eade58538e4d5f84b9546ff670f0b269cc21"
    sha256 cellar: :any,                 monterey:       "a67c2e4010a912fecef72d0fbd9f00d07eb90c9c830ceb4fa86f227a3a6a6351"
    sha256 cellar: :any,                 big_sur:        "8c6272502c92f53451b09b6c1d89ed799cbb7ca607dc1f7d348b29e3293debca"
    sha256 cellar: :any,                 catalina:       "e32f8f7ad53844881504d61dc68d9fa7a59a9e90001c490b0d611f844ad2f4af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97fccd25208c4636eca7e904d1b0f482e4392a6f0c1e7c4ce4d72678112b89f4"
  end

  depends_on "openssl@3"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/slowhttptest", "-u", "https://google.com",
                                  "-p", "1", "-r", "1", "-l", "1", "-i", "1"

    assert_match version.to_s, shell_output("#{bin}/slowhttptest -h", 1)
  end
end
