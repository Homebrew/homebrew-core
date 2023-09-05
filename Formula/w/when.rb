class When < Formula
  desc "Tiny personal calendar"
  homepage "https://www.lightandmatter.com/when/when.html"
  url "https://bitbucket.org/ben-crowell/when/get/1.1.45.tar.bz2"
  sha256 "fd614afe891b6e8e7b131041176e958fe00583c8300a3523ddfb7d65692a68df"
  license "GPL-2.0-only"
  head "https://bitbucket.org/ben-crowell/when.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "932e4d3a5887293dc38afaf08f11ffb073784eeaaab09828608278c0e3dd5a3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "932e4d3a5887293dc38afaf08f11ffb073784eeaaab09828608278c0e3dd5a3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "932e4d3a5887293dc38afaf08f11ffb073784eeaaab09828608278c0e3dd5a3a"
    sha256 cellar: :any_skip_relocation, ventura:        "932e4d3a5887293dc38afaf08f11ffb073784eeaaab09828608278c0e3dd5a3a"
    sha256 cellar: :any_skip_relocation, monterey:       "932e4d3a5887293dc38afaf08f11ffb073784eeaaab09828608278c0e3dd5a3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "932e4d3a5887293dc38afaf08f11ffb073784eeaaab09828608278c0e3dd5a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d49cbde109823dc26ff8f009d3ea47ec366f0fe459e3e36373797c486fc5ab08"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".when/preferences").write <<~EOS
      calendar = #{testpath}/calendar
    EOS

    (testpath/"calendar").write "2015 April 1, stay off the internet"
    system bin/"when", "i"
  end
end
