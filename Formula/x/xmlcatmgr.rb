class Xmlcatmgr < Formula
  desc "Manipulate SGML and XML catalogs"
  homepage "https://xmlcatmgr.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmlcatmgr/xmlcatmgr/2.2/xmlcatmgr-2.2.tar.gz"
  sha256 "ea1142b6aef40fbd624fc3e2130cf10cf081b5fa88e5229c92b8f515779d6fdc"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0fa2f9f885678ab72041ddd5e883d176ffccad39304fcf62c1eacedcdad5c972"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a5001b714208e85e53c79584088d9f1d710f82e450119e27ab4a4cd037f914b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2173a5a30ce2c4d47c35e9fef2eb19bc08e50203d59d4728d18ece3209cb2118"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab7701704b492dcdb3b27fba5423a0d45fd572188cb51461dbe344d83b10909a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "919144de2d285295b51f2fd50c480a89700c746ffcb3430ee8bb8c2dd6a12338"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27cda943918a3d692517e971f92a8e855d6b93c84eaf0646baff75a9f1f16c63"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e7b47b8b9d4fa78f3337c1da5a2e10ccbb3cac8237bc0f9444335d4f740bc6d"
    sha256 cellar: :any_skip_relocation, ventura:        "a363b397c78ed54867c5982f801f9c67307fff26d96905a93f7c22aa1be81733"
    sha256 cellar: :any_skip_relocation, monterey:       "c401c527f4babe7caee6af925027fb07d300961351548e9ccfed20c6be1ed6a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf19153b0ce232b3fe88cd0d2288a4d94056b3092a8c64483fec2634dc821605"
    sha256 cellar: :any_skip_relocation, catalina:       "ae788970290574145fa3ca20e389469f1a8582c8b604a50e3e506b7ffcb9faa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9194b26f616899f7d7edc8db1534c8e5f91fc46231d6e2aa0be1ea9374ff71d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52185546f22943c4a693619db91532acbac6e555e8d747156515af72542c0c43"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"xmlcatmgr", "-v"
  end
end
