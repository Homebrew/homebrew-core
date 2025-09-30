class When < Formula
  desc "Tiny personal calendar"
  homepage "https://www.lightandmatter.com/when/when.html"
  url "https://bitbucket.org/ben-crowell/when/get/1.1.45.tar.bz2"
  sha256 "fd614afe891b6e8e7b131041176e958fe00583c8300a3523ddfb7d65692a68df"
  license "GPL-2.0-only"
  head "https://bitbucket.org/ben-crowell/when.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "fb5fab0bd5a3c23aaac7bc49bed557d69c6e71e9691d9f855c6a30386dbe7002"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f0731698fde0d9766deb700635985822f9a76e1fe3f2a18ba74f4d8badafc785"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe1d8aaf972d667b218d7698246ae443830139cb7bed81719a5c8a0bba8ed799"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "932e4d3a5887293dc38afaf08f11ffb073784eeaaab09828608278c0e3dd5a3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "932e4d3a5887293dc38afaf08f11ffb073784eeaaab09828608278c0e3dd5a3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "932e4d3a5887293dc38afaf08f11ffb073784eeaaab09828608278c0e3dd5a3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe1d8aaf972d667b218d7698246ae443830139cb7bed81719a5c8a0bba8ed799"
    sha256 cellar: :any_skip_relocation, ventura:        "932e4d3a5887293dc38afaf08f11ffb073784eeaaab09828608278c0e3dd5a3a"
    sha256 cellar: :any_skip_relocation, monterey:       "932e4d3a5887293dc38afaf08f11ffb073784eeaaab09828608278c0e3dd5a3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "932e4d3a5887293dc38afaf08f11ffb073784eeaaab09828608278c0e3dd5a3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9c2be1a18694aca6968ccdba5d11fb8f6923a66c91f208ccec902b4bf51219c6"
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
