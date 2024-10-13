class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.9.0/sfk-1.9.9.tar.gz"
  version "1.9.9.0"
  sha256 "49cd73283495a254f8659cb0d96983239c34618892064c318b0c2d19861c7910"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(%r{url.*?swissfileknife/v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c15f73f78d4a56308802648f0cfe42b8dd9e95a74265ce125f83e5cc76b1c2f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb8fbb8e7011a96a46b2360621cef69dfa4ba2abe3351311b0d9a8e98cac979b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c83a6b2240645182e4fee20eba8b2f1cd4839e8d303e7ad2b2b27ea3f56d004"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2643c14bcd03fb0329cac96cc7618e1d5c0043b897a2ef052f95742864b11d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6cd03f5ad050d40222b8e171f9110af1f4ecca00526b888b0c1c3233991efdb"
    sha256 cellar: :any_skip_relocation, sonoma:         "402851379e28f440ba5108289fb8432af229603c7d1842cb6bd296b5c90866a9"
    sha256 cellar: :any_skip_relocation, ventura:        "20a18a26d5d135a30e02179b3c320fd73d14a277daef1ef1b368024365c314f5"
    sha256 cellar: :any_skip_relocation, monterey:       "11c813b0e1a0723b23ef70e3e690d9a3b9fc48a7e0f6963072115c566f447089"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0ad0b68e278ed0e44bec1031e69d8030aec29f72f2158258d15b8d7fbe9c0b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "451296cebcfe315794072f07817f0269af01caac2a416ee9b58e99a29055617e"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"sfk", "ip"
  end
end
