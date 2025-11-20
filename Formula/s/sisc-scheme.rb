class SiscScheme < Formula
  desc "Extensive Java based Scheme interpreter"
  homepage "https://sisc-scheme.org/"
  url "https://downloads.sourceforge.net/project/sisc/SISC%20Lite/1.16.6/sisc-lite-1.16.6.tar.gz"
  sha256 "7a2f1ee46915ef885282f6df65f481b734db12cfd97c22d17b6c00df3117eea8"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later"]

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "cc07c73860b9acfbad278e89277cacd790f4b5ac3de3800352d8ac6d6e833ccb"
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
