class SiscScheme < Formula
  desc "Extensive Java based Scheme interpreter"
  homepage "https://sisc-scheme.org/"
  url "https://downloads.sourceforge.net/project/sisc/SISC%20Lite/1.16.6/sisc-lite-1.16.6.tar.gz"
  sha256 "7a2f1ee46915ef885282f6df65f481b734db12cfd97c22d17b6c00df3117eea8"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7e9295240559052f8c4e4b075ed560b0809c92c8d6d48c4b020707c5dcb20b01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e01048572a3944b67dd73804391d0cad34e81ecdb5ec39455f5eddad3175c3c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f65d81b8af3efb3351510362fdde92e8b9fc5a32eaba361a438abed4fb265991"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f65d81b8af3efb3351510362fdde92e8b9fc5a32eaba361a438abed4fb265991"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f65d81b8af3efb3351510362fdde92e8b9fc5a32eaba361a438abed4fb265991"
    sha256 cellar: :any_skip_relocation, sonoma:         "45b8e7de8b9d09fb4680118c7aec9d81be8e6535e595754d1722be7a863daac6"
    sha256 cellar: :any_skip_relocation, ventura:        "e76fa3836cfb1020d76de3ccda011d84223260860c78372930dbe99eeef6f46b"
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
