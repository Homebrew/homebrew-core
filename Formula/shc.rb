class Shc < Formula
  desc "Shell Script Compiler"
  homepage "https://neurobin.github.io/shc"
  url "https://github.com/neurobin/shc/archive/4.0.3.tar.gz"
  sha256 "7d7fa6a9f5f53d607ab851d739ae3d3b99ca86e2cb1425a6cab9299f673aee16"
  license "GPL-3.0"
  head "https://github.com/neurobin/shc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3866195be89821e424dca28e390d36060ad52be9030677498a300e39b7ece548" => :big_sur
    sha256 "fd153e413029832fb17b013fb15d43aab1e1e22b618d58c768a049ac31e0759c" => :arm64_big_sur
    sha256 "cdfc62c7d9bd39ed7e956066f8d55a189c58b185b6abf7e45b5d8c63a6abe2d5" => :catalina
    sha256 "ff3c55ef1d10c16066e97a20143dbd1e7781ceb9a2c5c8b46d140f6711bc79fa" => :mojave
    sha256 "c19f4586119be579006eace517045998138d83a17e2b5c8ec00ad73ea007b68c" => :high_sierra
    sha256 "6e1834ac7b4cc64ba972a59189512bb9ff9e0ec307df78f9e0fc1fee42378f6d" => :sierra
  end

  def install
    system "./configure"
    system "make", "install", "prefix=#{prefix}"
    pkgshare.install "test"
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/bin/sh
      echo hello
      exit 0
    EOS
    system bin/"shc", "-f", "test.sh", "-o", "test"
    assert_equal "hello", shell_output("./test").chomp
  end
end
