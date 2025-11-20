class Rkhunter < Formula
  desc "Rootkit hunter"
  homepage "https://rkhunter.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/rkhunter/rkhunter/1.4.6/rkhunter-1.4.6.tar.gz"
  sha256 "f750aa3e22f839b637a073647510d7aa3adf7496e21f3c875b7a368c71d37487"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6b58dd966408841d1c6bb19fa135f3eec96744806fba465a04b294c28c906839"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5635d3ac60704bc062b8336a912daa80d97cf9fd8d847572c55d82b8e87bbd60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b2a4538360218a1f44f63eb61a24e6b9ecc36dfc613dfb2c404f10f8cb75a7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0352661692f5a34e6febf6822eb3e1eb212e5aefd2189ee403def6acf247a38a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c3872b26c375898fbc61439a6605f42c59e1ad11a339e551d6788c29794cc88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d560c35e3fef71d00f5ea9ee54e3f175f39e0c3fabdd1e141cc247c2a886d91"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0e854c86f509718bc7c3acc2da1d7228405179dbef528c449bd091ce104e189"
    sha256 cellar: :any_skip_relocation, ventura:        "3db88c3dd06a9a6b84773472428a17fb1b8133dd7fec11781a32b185a89ad65b"
    sha256 cellar: :any_skip_relocation, monterey:       "6e7b220d8e9f61934488d2858254db636b1dddbe96512ed01a1b3a81d03f4e3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "398958bdafc37011a76efa6e6d2fefc8c34964eb6ba29a0f6823fb8c1058e9c5"
    sha256 cellar: :any_skip_relocation, catalina:       "e9bfbf9e122295e1fd4ac70dea7502856b3415e0eec187512f196d51a718ab92"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6484f6217389b50e66ad8f992e532cb19e9fd27330510d2303060c2f7de70bbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85138f7ce8fcb3790c94d0322d64315e3d683e50a6a690700b7600cd4ce1fda1"
  end

  def install
    system "./installer.sh", "--layout", "custom", prefix, "--install"
  end

  test do
    system bin/"rkhunter", "--version"
  end
end
