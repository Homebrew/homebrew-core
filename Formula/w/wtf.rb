class Wtf < Formula
  desc "Translate common Internet acronyms"
  homepage "https://sourceforge.net/projects/bsdwtf/"
  url "https://downloads.sourceforge.net/project/bsdwtf/wtf-20230804.tar.gz"
  sha256 "855b93b2b9a5d69c50add2daf125968ba019a34eedeefc0a064fb07e27066e41"
  license :public_domain

  livecheck do
    url :stable
    regex(%r{url=.*?/wtf[._-]v?(\d{6,8})\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "59bf03ad4baa9687fef5a24f8fbe907c6b309f3a5c45d63a8e02b49cb8558f77"
  end

  def install
    inreplace %w[wtf wtf.6], "/usr/share", share
    bin.install "wtf"
    man6.install "wtf.6"
    (share+"misc").install %w[acronyms acronyms.comp]
    (share+"misc").install "acronyms-o.real" => "acronyms-o"
  end

  test do
    assert_match "where's the food", shell_output("#{bin}/wtf wtf")
  end
end
