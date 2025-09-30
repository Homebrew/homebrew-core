class Vcprompt < Formula
  desc "Provide version control info in shell prompts"
  homepage "https://github.com/powerman/vcprompt"
  url "https://github.com/powerman/vcprompt/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "3db5ebad2e333d43b464b665c8d43b35156b0f144052f10c340a5c5007a6874d"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c88613793fa29e4eef8e6871f9974a4486fc0129194e7ceafe26d257a253d06c"
    sha256 cellar: :any,                 arm64_sequoia: "647b480e6f4b4168c0c89405dfa6351f9a0ae16065be2a90c9822ae958cc789f"
    sha256 cellar: :any,                 arm64_sonoma:  "aea4d0a7c13f68e976cfb12ffb42b2ad3d7cbacb46ba0716039d72a8027401e4"
    sha256 cellar: :any,                 arm64_ventura: "a83a4e89e903a4d9c4ec2110d37bac60d699247a24efd4f880787243b090a1ef"
    sha256 cellar: :any,                 sonoma:        "172c06fc8931c12d95d40773f0660aa5d26810ef44e9f9007d5b9f116cded777"
    sha256 cellar: :any,                 ventura:       "64f638de25d6b06d7a10829a1414982c457bd4d53277b2d7ec172e1a07884362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "444f2645da1b8fe40ecc443ab2aa1ca804fa85da5a96c189b54fd1708e1c7037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d41e332c1f9175c9e63429921c6e96490e6cec5e785736f3a844cb8f9b4da873"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "sqlite"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "PREFIX=#{prefix}",
                   "MANDIR=#{man1}",
                   "install"
  end

  test do
    system bin/"vcprompt"
  end
end
