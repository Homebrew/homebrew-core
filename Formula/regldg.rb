class Regldg < Formula
  desc "Regular expression grammar language dictionary generator"
  homepage "https://regldg.com/"
  url "https://regldg.com/regldg-1.0.1.tar.gz"
  sha256 "f5f401c645a94d4c737cefa2bbcb62f23407d25868327902b9c93b501335dc99"
  license "MIT"

  livecheck do
    url "https://regldg.com/download.html"
    regex(/href=.*?regldg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11ec4d993c71645c53d5eda04bc1fd8b54c3427b552331ff09b1dec8042cf244"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98548aa0c1df33ee57ed002fa10dcc0abbe4d7c6cbd4ac5e03eca3cab08f6dec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c395a7406c24b3b1f4138a48f97f39fe48200e5f41f7b42a8d577e76c72150f"
    sha256 cellar: :any_skip_relocation, ventura:        "424f7bad0d29a37bdd656970ef4042e473a63fd67111cd935611860d1902c41a"
    sha256 cellar: :any_skip_relocation, monterey:       "61e9dbff3e2066040078bec8de5d0d5ea9204fe51f77c37b584fc6b514930051"
    sha256 cellar: :any_skip_relocation, big_sur:        "1380e8c5743f9f4e4b42ea800a51081bb9c64046c045ea13d024f5cb57285561"
    sha256 cellar: :any_skip_relocation, catalina:       "da76db370a17393f11d51e58c6a859fbfa9cc1d4a79bd225757c2f130ed016c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10b3273bf707f57edf849eb44f1eb7d86e61082cc899cdffe80aa04c550177fb"
  end

  def install
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    inreplace "Makefile", "-o regldg", "-o regldg -lm" unless OS.mac?
    system "make"
    bin.install "regldg"
  end

  test do
    system "#{bin}/regldg", "test"
  end
end
