class WithReadline < Formula
  desc "Allow GNU Readline to be used with arbitrary programs"
  homepage "https://www.greenend.org.uk/rjk/sw/withreadline.html"
  url "https://www.greenend.org.uk/rjk/sw/with-readline-0.1.1.tar.gz"
  sha256 "d12c71eb57ef1dbe35e7bd7a1cc470a4cb309c63644116dbd9c88762eb31b55d"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?with-readline[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "64699e89e796bf016bb6754677c5a76f881111becdbbea0ae532de8e9f398932"
    sha256 cellar: :any,                 arm64_sonoma:   "5aeb8225f4f4897af246a0e1b4042375539336d0b80721968d50f4760157b5e2"
    sha256 cellar: :any,                 arm64_ventura:  "b3277d7237d984e25ce8eea7a479b7ac6c68c929fbcfcee627d68e2748eb955d"
    sha256 cellar: :any,                 arm64_monterey: "d0fbb8e109734765f470ff267c0c45f3ae958615bc162f3e541b9e4f219d7ec9"
    sha256 cellar: :any,                 arm64_big_sur:  "7a8f7ff1d33453d059ac6ac6b23883fa3f86d720cb25415e590e81ca2e6255dd"
    sha256 cellar: :any,                 sonoma:         "04cd5b6bff3d1ae6daddbd45dfdc42864b84a2061191573561b35bf001dd57b0"
    sha256 cellar: :any,                 ventura:        "e4a501c322f47879d36712e61bb9dc2885b2b3ec66e5e44b8f44c3fbdbb53b25"
    sha256 cellar: :any,                 monterey:       "96e916f5b1f84b40c4aca915dce1731428e4fadf69269932098a8ffa87168554"
    sha256 cellar: :any,                 big_sur:        "0700f15130da53328bff304e2cfdb422ad2bc4fff64a0377063af94cf46d3655"
    sha256 cellar: :any,                 catalina:       "b0ba2ed66eff2c432234e5885ebeca2a671bb556024ad038563883b3c14a64b4"
    sha256 cellar: :any,                 mojave:         "3a6e8e8e2d6f35ecd215b969c3794e586b1209820a9b0e5d935ddc5363f58678"
    sha256 cellar: :any,                 high_sierra:    "72ea8c0cce2f94fae5c963a1113c9b2504f1d728234c3c511ad7e3d5dca0d74b"
    sha256 cellar: :any,                 sierra:         "808a3a96b1d247f16c0a3e21eb18ed287f7df474b36c4685725768a05c3c1c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa9469fdae3e63ea2e6bba4850d405878c6a782b703f978ee04e28a49285e39b"
  end

  depends_on "readline"

  uses_from_macos "tcl-tk" => :test

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    tclsh = OS.mac? ? "/usr/bin/tclsh" : Formula["tcl-tk"].bin/"tclsh"
    pipe_output("#{bin}/with-readline #{tclsh}", "exit", 0)
  end
end
