class Shc < Formula
  desc "Shell Script Compiler"
  homepage "https://neurobin.github.io/shc"
  url "https://github.com/neurobin/shc/archive/4.0.3.tar.gz"
  sha256 "7d7fa6a9f5f53d607ab851d739ae3d3b99ca86e2cb1425a6cab9299f673aee16"
  license "GPL-3.0"
  head "https://github.com/neurobin/shc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e84ca021ebfbeaa652c74a9e07b3eddfc390c4193f64effdd93d835958d7e90c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd153e413029832fb17b013fb15d43aab1e1e22b618d58c768a049ac31e0759c"
    sha256 cellar: :any_skip_relocation, monterey:       "8896b46bb8b312f24f98ae842c8edb5c7ba1321c21f9441c32c8218a15c596c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "3866195be89821e424dca28e390d36060ad52be9030677498a300e39b7ece548"
    sha256 cellar: :any_skip_relocation, catalina:       "cdfc62c7d9bd39ed7e956066f8d55a189c58b185b6abf7e45b5d8c63a6abe2d5"
    sha256 cellar: :any_skip_relocation, mojave:         "ff3c55ef1d10c16066e97a20143dbd1e7781ceb9a2c5c8b46d140f6711bc79fa"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c19f4586119be579006eace517045998138d83a17e2b5c8ec00ad73ea007b68c"
    sha256 cellar: :any_skip_relocation, sierra:         "6e1834ac7b4cc64ba972a59189512bb9ff9e0ec307df78f9e0fc1fee42378f6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a659b8f040806dcf7303f42a3cc50eb61acf894c9d2066acefd897dc71f1452"
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
