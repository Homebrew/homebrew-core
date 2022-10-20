class SiscScheme < Formula
  desc "Extensive Java based Scheme interpreter"
  homepage "http://sisc-scheme.org/"
  url "https://downloads.sourceforge.net/project/sisc/SISC%20Lite/1.16.6/sisc-lite-1.16.6.tar.gz"
  sha256 "7a2f1ee46915ef885282f6df65f481b734db12cfd97c22d17b6c00df3117eea8"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f65d81b8af3efb3351510362fdde92e8b9fc5a32eaba361a438abed4fb265991"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f65d81b8af3efb3351510362fdde92e8b9fc5a32eaba361a438abed4fb265991"
    sha256 cellar: :any_skip_relocation, monterey:       "e76fa3836cfb1020d76de3ccda011d84223260860c78372930dbe99eeef6f46b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e76fa3836cfb1020d76de3ccda011d84223260860c78372930dbe99eeef6f46b"
    sha256 cellar: :any_skip_relocation, catalina:       "e76fa3836cfb1020d76de3ccda011d84223260860c78372930dbe99eeef6f46b"
    sha256 cellar: :any_skip_relocation, mojave:         "e76fa3836cfb1020d76de3ccda011d84223260860c78372930dbe99eeef6f46b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f65d81b8af3efb3351510362fdde92e8b9fc5a32eaba361a438abed4fb265991"
  end

  def install
    libexec.install Dir["*"]
    (bin/"sisc").write <<~EOS
      #!/bin/sh
      SISC_HOME=#{libexec}
      exec #{libexec}/sisc "$@"
    EOS
  end
end
