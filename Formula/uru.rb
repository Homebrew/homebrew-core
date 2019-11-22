class Uru < Formula
  desc "Use multiple rubies on multiple platforms"
  homepage "https://bitbucket.org/jonforums/uru"
  url "https://bitbucket.org/jonforums/uru/get/v0.8.5.tar.gz"
  sha256 "47148454f4c4d5522641ac40aec552a9390a2edc1a0cd306c5d16924f0be7e34"

  bottle do
    cellar :any_skip_relocation
    sha256 "d566fe465acd16153f2b1da700bacb19bb3fd78bfe13b055f255cd3b68688233" => :catalina
    sha256 "25c90f23ff4d5225d439f8783d25d440ee2b7fc6e8afdc5772914deab0ae3184" => :mojave
    sha256 "d6da062bd8e0d7134a9d98285344064a82329b138bd7e0ed14fbc01a27530079" => :high_sierra
    sha256 "fb1b6ac6bd09955f072e9b65e92cc992b6da4a14640694d8a830aaacad944518" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/bitbucket.org/jonforums/uru").install Dir["*"]
    system "go", "build", "-ldflags", "-s", "bitbucket.org/jonforums/uru/cmd/uru"
    bin.install "uru" => "uru_rt"
  end

  def caveats; <<~EOS
    Append to ~/.profile on Ubuntu, or to ~/.zshrc on Zsh
    $ echo 'eval "$(uru_rt admin install)"' >> ~/.bash_profile
  EOS
  end

  test do
    system "#{bin}/uru_rt"
  end
end
