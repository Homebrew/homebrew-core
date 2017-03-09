class Zpm < Formula
  desc "zsh plugin manager in ansi C"
  homepage "https://github.com/zpm-project/zpm-zsh"
  url "https://github.com/zpm-project/zpm-zsh/archive/v0.1.0.tar.gz"
  sha256 "113ec66a7fc292133146018b74e050b924d5dfa31741e4da14995b3fed641a18"
  head "https://github.com/zpm-project/zpm-zsh.git"

  resource "url.h" do
    url "https://github.com/jwerle/url.h/archive/a65623ad107be19ca4efb5a36379f3440eb48091.tar.gz"
    sha256 "4b454091653b811a0a09c7b4a43c9644daa4f3806c586d6f3c497b58cb9b6953"
  end

  def install
    resource("url.h").stage do
      cp "url.h", "#{buildpath}/url.h/"
    end

    mkdir bin
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "make", "test"
  end
end
