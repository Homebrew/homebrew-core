class Xpa < Formula
  desc "Seamless communication between Unix programs"
  homepage "https://hea-www.harvard.edu/RD/xpa/"
  url "https://github.com/ericmandel/xpa/archive/2.1.20.tar.gz"
  sha256 "854af367c0f4ffe7a65cb4da854a624e20af3c529f88187b50b22b68f024786a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad3b920ba7f22f7fecc369c4eb3f093d6f519fb24ca7c8bf90a0cbda4fc9a3b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfe65258684be3dee93bc7c0649abc8496e359b1fc16baa5430e562c1c0e2361"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b22cf494e2ca55efce9a08463ddd9ef4044af0a479689aa5ab610e40465fc93"
    sha256 cellar: :any_skip_relocation, ventura:        "72b8a37979de78f7d54a8e89e7f8058664276d184d185a3ddf849ca0e6dd36a2"
    sha256 cellar: :any_skip_relocation, monterey:       "01998b97fd193560c96334d78e40278d7bd3bc645416dd809740e97c04cf02d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "025fa588033850451ca384e0274dd96d29c6e9e1331fd09aa82aad0bb2289af5"
    sha256 cellar: :any_skip_relocation, catalina:       "223dc44eba3ff66b59c26e53e9d0ab14c63d57e2f76786bae9fdb7a2be5bbdac"
    sha256 cellar: :any_skip_relocation, mojave:         "6ba46da9e3de8719db32f1f577fb6943be03a58f8c6472ef7f9b398d0fea9743"
    sha256 cellar: :any_skip_relocation, high_sierra:    "686a14717f6ae1b2af6230c3568622f9a480f8884cfee0924ffbecbee8b33db9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b81c4534c71e50918a8be11796766e6b75b27c40560c08ae1e12071e96c0bfc3"
  end

  deprecate! date: "2022-10-01", because: :unmaintained

  depends_on "libxt" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # relocate man, since --mandir is ignored
    mv "#{prefix}/man", man
  end
end
