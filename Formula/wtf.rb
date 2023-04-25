class Wtf < Formula
  desc "Translate common Internet acronyms"
  homepage "https://sourceforge.net/projects/bsdwtf/"
  url "https://downloads.sourceforge.net/project/bsdwtf/wtf-20230404.tar.gz"
  sha256 "73623643de43a6b16528f7508eadd109c527c6f12c2abec2442096c06050b1d0"
  license :public_domain

  livecheck do
    url :stable
    regex(%r{url=.*?/wtf[._-]v?(\d{6,8})\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ec046822afb981a5ea83ca7a3d9df18372ff6e520157c9e7db04d020f8d1a16"
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
