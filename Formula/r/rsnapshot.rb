class Rsnapshot < Formula
  desc "File system snapshot utility (based on rsync)"
  homepage "https://www.rsnapshot.org/"
  url "https://github.com/rsnapshot/rsnapshot/releases/download/1.4.5/rsnapshot-1.4.5.tar.gz"
  sha256 "10b75e01ca25511e8266aacd495531975ad1a8ad556216b6a57c76d028b38242"
  license "GPL-2.0-or-later"
  head "https://github.com/rsnapshot/rsnapshot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0b18ffa55da1caa2cbddf3b7a16a21a0de262b2aa4d731162ab9599a68b42721"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ffe1eafe7c869b14ade9f1befcb45e41eea2ed44e82fb4ad03181e5753c90ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb30e80a6c1393883b9cfb841bbbd36aa9dcbfc37bfe785d5a7cf70f8e22a281"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb30e80a6c1393883b9cfb841bbbd36aa9dcbfc37bfe785d5a7cf70f8e22a281"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb30e80a6c1393883b9cfb841bbbd36aa9dcbfc37bfe785d5a7cf70f8e22a281"
    sha256 cellar: :any_skip_relocation, sonoma:         "6807c58f2cf0d19782c9647f532674c3b70f130b1dccba7741a0dafe141a0f83"
    sha256 cellar: :any_skip_relocation, ventura:        "4e1c7b09d6afb52057774ba26f8f8c6b3831ca785583ad3909df990f4f84ada6"
    sha256 cellar: :any_skip_relocation, monterey:       "4e1c7b09d6afb52057774ba26f8f8c6b3831ca785583ad3909df990f4f84ada6"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e1c7b09d6afb52057774ba26f8f8c6b3831ca785583ad3909df990f4f84ada6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e59bc654d0b031d30e75d49ddc369bde52ce3517127febe09cd128f331a76cb"
  end

  uses_from_macos "rsync" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"rsnapshot", "--version"
  end
end
