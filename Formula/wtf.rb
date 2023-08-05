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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cf16df1cfb1a5013590f3386721b6109b93d2c123949f613c5bd935698920f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cf16df1cfb1a5013590f3386721b6109b93d2c123949f613c5bd935698920f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cf16df1cfb1a5013590f3386721b6109b93d2c123949f613c5bd935698920f5"
    sha256 cellar: :any_skip_relocation, ventura:        "1cf16df1cfb1a5013590f3386721b6109b93d2c123949f613c5bd935698920f5"
    sha256 cellar: :any_skip_relocation, monterey:       "1cf16df1cfb1a5013590f3386721b6109b93d2c123949f613c5bd935698920f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cf16df1cfb1a5013590f3386721b6109b93d2c123949f613c5bd935698920f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f55958ea25be7538ee42bd7404f2242193594baf52b174ebbff169e7a4163ceb"
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
