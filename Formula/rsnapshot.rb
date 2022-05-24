class Rsnapshot < Formula
  desc "File system snapshot utility (based on rsync)"
  homepage "https://www.rsnapshot.org/"
  url "https://github.com/rsnapshot/rsnapshot/releases/download/1.4.4/rsnapshot-1.4.4.tar.gz"
  sha256 "c1cb7cb748c5a9656c386362bdf6c267959737724abb505fbf9e940a9d988579"
  license "GPL-2.0"
  head "https://github.com/rsnapshot/rsnapshot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51bde7434f2ad12b3d0ce70396665ab1d636e41639a87ec7da43f7d5a57ef991"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3b962467213ee16410bc0e619994698c176ca9795ddb6f6087dbba934687144"
    sha256 cellar: :any_skip_relocation, monterey:       "b80d39853be289fe0056893db5c0f977540a01704e65eb0a12168761a62c137d"
    sha256 cellar: :any_skip_relocation, big_sur:        "18ba069ea2a52a986acf2027299e9ae5d85593c011361e2448f3b54752e42078"
    sha256 cellar: :any_skip_relocation, catalina:       "9d5272a4186bd3d895a5491bac76e66e3cac54e906bf03022d6ea7ad421b8fd8"
    sha256 cellar: :any_skip_relocation, mojave:         "9d5272a4186bd3d895a5491bac76e66e3cac54e906bf03022d6ea7ad421b8fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "167623261bb7075b7f2bd0c781c0ca08c081bb4f8ce4166cd3da6ce671575fe8"
  end

  uses_from_macos "rsync" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/rsnapshot", "--version"
  end
end
