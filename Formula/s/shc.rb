class Shc < Formula
  desc "Shell Script Compiler"
  homepage "https://neurobin.github.io/shc"
  url "https://github.com/neurobin/shc/archive/refs/tags/4.0.3.tar.gz"
  sha256 "7d7fa6a9f5f53d607ab851d739ae3d3b99ca86e2cb1425a6cab9299f673aee16"
  license "GPL-3.0-or-later"
  head "https://github.com/neurobin/shc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0e1db3eca184dfad518ba0f0ab5a1d4c66f34aca3097f44610a5471882ca311"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d30b347144b581af9b318135d285030075c9e00df94728b8e1430b7fa69606f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e84ca021ebfbeaa652c74a9e07b3eddfc390c4193f64effdd93d835958d7e90c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd153e413029832fb17b013fb15d43aab1e1e22b618d58c768a049ac31e0759c"
    sha256 cellar: :any_skip_relocation, sonoma:         "986e78b01d80d0b0299147bc07ae137cfae98ccf26468cac072e60d1aab25460"
    sha256 cellar: :any_skip_relocation, ventura:        "b08711bc5713b2cafa6ae423220b9f6f7046d2c2a4aa3d0c9d88104b6f64a8b6"
    sha256 cellar: :any_skip_relocation, monterey:       "8896b46bb8b312f24f98ae842c8edb5c7ba1321c21f9441c32c8218a15c596c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "3866195be89821e424dca28e390d36060ad52be9030677498a300e39b7ece548"
    sha256 cellar: :any_skip_relocation, catalina:       "cdfc62c7d9bd39ed7e956066f8d55a189c58b185b6abf7e45b5d8c63a6abe2d5"
    sha256 cellar: :any_skip_relocation, mojave:         "ff3c55ef1d10c16066e97a20143dbd1e7781ceb9a2c5c8b46d140f6711bc79fa"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c19f4586119be579006eace517045998138d83a17e2b5c8ec00ad73ea007b68c"
    sha256 cellar: :any_skip_relocation, sierra:         "6e1834ac7b4cc64ba972a59189512bb9ff9e0ec307df78f9e0fc1fee42378f6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a659b8f040806dcf7303f42a3cc50eb61acf894c9d2066acefd897dc71f1452"
  end

  def install
    system "./configure", *std_configure_args
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
