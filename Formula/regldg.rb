class Regldg < Formula
  desc "Regular expression grammar language dictionary generator"
  homepage "https://regldg.com/"
  url "https://regldg.com/regldg-1.0.0.tar.gz"
  sha256 "cd550592cc7a2f29f5882dcd9cf892875dd4e84840d8fe87133df9814c8003f1"

  livecheck do
    url "https://regldg.com/download.php"
    regex(/href=.*?regldg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84337b697dfc598e216c2f685845c33a07974c77f4960219033e6d113e7dd855"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6456b6abf558106d2cae0459145d3070b07dc37d3757f84d325f11aaa7badf4"
    sha256 cellar: :any_skip_relocation, monterey:       "225f02260bee0c943540cec131c5b3047e3306438b2d8c39f879fdc8d2dd4478"
    sha256 cellar: :any_skip_relocation, big_sur:        "30966f99bf5fa0f3af539ce5b8eaca2666db734ac561d2b3a261532636b2a54c"
    sha256 cellar: :any_skip_relocation, catalina:       "6c69006dc5eb93be0eb6b39cb396e59e8c09aa5d65f56a216cd19753a7f28232"
    sha256 cellar: :any_skip_relocation, mojave:         "15f7e95f3d84d091a942e836ab9a27b3df2594e3f378da26f10371e7ba01be5c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "45950c0b432b227711570e3b9ea79fe9bf96b3239a062c5a736f9a3fdf294fb5"
    sha256 cellar: :any_skip_relocation, sierra:         "26f12ca7e41b36a167d94f403b97557490fd1ad0ed1a2d4d0b30c86164ae9d39"
    sha256 cellar: :any_skip_relocation, el_capitan:     "52c64d6766b68a1ed602d3878368109d3ac3e5e60d6fc14a4606518d14f6e678"
    sha256 cellar: :any_skip_relocation, yosemite:       "c4157a77e2620b868b2dbbb3ebf126193b238c6a69d2a895420950d4203d7a17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69cdbf331fd88fc5891aadd99835d8497f30a27a5bc42c3e10c0d32792f43d0c"
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
