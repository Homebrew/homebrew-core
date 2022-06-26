class Weggli < Formula
  desc "Fast and robust semantic search tool for C and C++ codebases"
  homepage "https://github.com/googleprojectzero/weggli"
  url "https://github.com/googleprojectzero/weggli/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "12fde9a0dca2852d5f819eeb9de85c4d11c5c384822f93ac66b2b7b166c3af78"
  license "Apache-2.0"
  head "https://github.com/googleprojectzero/weggli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9022a081ad91f76f56ba573b33d9162e31907c4fd3af5a170cb2c645734a03ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "191de3fc48b48dd3767b93168af897b072a0c8805e80390096b508ff76ff284a"
    sha256 cellar: :any_skip_relocation, monterey:       "4f378b97c3edc8a6f0a5e7c6c5d12e048c3bce8a0abe437c28bbcfa36eaf042b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3033702205d41d02c7182823ec178f7ae351dca235e08fca842c774809e1b5c1"
    sha256 cellar: :any_skip_relocation, catalina:       "7a5f9d5071d97301971c9504da05f02dc51ec6ea551da0c1f8d6b2a9e824816a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bd48098bc937bb9a40ccd1d56e00e0996a21f1b80b6259ac44a5b7e07a6ed78"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.c").write("void foo() {int bar=10+foo+bar;}")
    system "#{bin}/weggli", "{int $a = _+foo+$a;}", testpath/"test.c"
  end
end
