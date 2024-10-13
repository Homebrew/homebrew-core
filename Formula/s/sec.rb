class Sec < Formula
  desc "Event correlation tool for event processing of various kinds"
  homepage "https://simple-evcorr.sourceforge.net/"
  url "https://github.com/simple-evcorr/sec/releases/download/2.9.2/sec-2.9.2.tar.gz"
  sha256 "97c8bde4bcb8d7bacef6e186acfae4f6037928dc308fecc69db82d16267a18d2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4194b7583221cca53ec30a6b5ae227690cd9e28c2c3a711b5e2737b727b29ae8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f56aa1eb7072755094229591f880fd463fd182b62f1e529c74e791ea52c84e7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82ebeeaa60f814baf3107625b4e1dbef815e8a975f27e757ff63ddb7f2d68177"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82ebeeaa60f814baf3107625b4e1dbef815e8a975f27e757ff63ddb7f2d68177"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82ebeeaa60f814baf3107625b4e1dbef815e8a975f27e757ff63ddb7f2d68177"
    sha256 cellar: :any_skip_relocation, sonoma:         "86e9d076aa99c0e90613cca2db58e4d0be283aaead323e1b6dbb382e82cfc5ca"
    sha256 cellar: :any_skip_relocation, ventura:        "bb763c6512f48e838cb6dfcecd8df1073b2aa453e7ffdf74c58eaafaddfdd7c0"
    sha256 cellar: :any_skip_relocation, monterey:       "bb763c6512f48e838cb6dfcecd8df1073b2aa453e7ffdf74c58eaafaddfdd7c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb763c6512f48e838cb6dfcecd8df1073b2aa453e7ffdf74c58eaafaddfdd7c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82ebeeaa60f814baf3107625b4e1dbef815e8a975f27e757ff63ddb7f2d68177"
  end

  def install
    bin.install "sec"
    man1.install "sec.man" => "sec.1"
  end

  test do
    system bin/"sec", "--version"
  end
end
