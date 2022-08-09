class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-279.tar.bz2"
  sha256 "667344f82868991344f4e1f5317edd17349b7a9afeb55b3958108195d580b3f5"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "6cf31060d8419e59dec20d5a8248abc93c80c2590ba202f6da786782ace599d3"
    sha256 cellar: :any, arm64_big_sur:  "cb172dd29555b5c5b54b82dd455dcba6032248e2a927c2f46746710c5262e1f9"
    sha256 cellar: :any, monterey:       "a299e59b993c1dc325a6bf67a2c4e6d9741a79d45c8d60d3f007978d4339071e"
    sha256 cellar: :any, big_sur:        "950f52091914640ab31afbe1c51e88fc2bf23aebc6c99ba82db4511293240bbd"
    sha256 cellar: :any, catalina:       "63f7d7c193c2e8e48d7a117dbbcc76a5814b93bbf308097bb72ae4d1aa0b7158"
  end

  depends_on "libffi"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
