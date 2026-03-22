class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/2.0.0.3/sfk-2.0.0.tar.gz"
  version "2.0.0.3"
  sha256 "b7e2e3848e3126dcee916056bff5f8340acae9158f3610049de2cde999ccca63"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(%r{url.*?swissfileknife/v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec3b6117f51420212e6d8d7731790f6f993609d8c254888c2141bdf707b69460"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "573b78680c4804e1fe8e8937087659d321737e865616f47939593f0f78dbc19e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4bb8c90c12c6644180c9b0426525284e0e8de58d5d10fcdd807ab7b53e58c9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "886b7876e56e345dc272b73a935567c19845b01e2804cd7cb02104c5540d0dfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "456e00f73c8dee5195cd6ef368ae9d904d4ed977dd944421c81f806356910747"
    sha256 cellar: :any_skip_relocation, ventura:       "76e519990b5a6a5eb48fc6b5c659c94d6fded8a9368ad059235836950aa6023c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27e7c02deb14c7fbac1e8c0a4a55872117a37a6ae6772556f3df1bbd193342a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfdc12016754b27340f7e11d07912c36471a2645f4ac0c39e9eaddce5b599d6f"
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
