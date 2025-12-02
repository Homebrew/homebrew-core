class Uru < Formula
  desc "Use multiple rubies on multiple platforms"
  homepage "https://bitbucket.org/jonforums/uru"
  url "https://bitbucket.org/jonforums/uru/get/v0.8.5.tar.gz"
  sha256 "47148454f4c4d5522641ac40aec552a9390a2edc1a0cd306c5d16924f0be7e34"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "93a4aa65b18a37ece4076353fdfee72392dae4a84118ac70e25d0cdd2829ae63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b5422b52374d4e7de9f934714fabe3b984a1e76fb795cc82cdac81c7477bbcf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19c329e3ad2a981d5edcf2f708608297f4b3d5da68c8344744cb78cffd513c42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1c97e2f9106da354206149ff4138bc8731b9e68675d57e2080c19bd2951c23c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afe47dce0be291a7c3c15d9723f5892164d4b72a481747bf2e1f74a1ba7b56fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70e3160416c65e40510431b1bd79105074505ceb63f9619451783eda48cd29e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5efa8d6b97be0d898916806359703001ee9438789edf69e171e74b7cd28f5068"
    sha256 cellar: :any_skip_relocation, ventura:        "aeb836f9cc4bc8f40f488f21abb3ca10bc2d20364e961737a541e0856c9b38fa"
    sha256 cellar: :any_skip_relocation, monterey:       "85e032eb3924d873d80f6358a5ea0e05b60cb1f28edb22d16d34bdd7ba164ff9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac10ec7e98c10782f1b238e768a7f4b2cd7c51040a2db171d731afb9c41130c0"
    sha256 cellar: :any_skip_relocation, catalina:       "d566fe465acd16153f2b1da700bacb19bb3fd78bfe13b055f255cd3b68688233"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3457892313460eef01491b76a45a15a2acca89237f911a482137fb09dcfa6c82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36ec6869ab83065e9bc5a08b7a4ec769297c4e608bc85001886d73598919c6cb"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/bitbucket.org/jonforums/uru").install Dir["*"]
    system "go", "build", "-ldflags", "-s", "bitbucket.org/jonforums/uru/cmd/uru"
    bin.install "uru" => "uru_rt"
  end

  def caveats
    <<~EOS
      Append to ~/.profile on Ubuntu, or to ~/.zshrc on Zsh
      $ echo 'eval "$(uru_rt admin install)"' >> ~/.bash_profile
    EOS
  end

  test do
    system bin/"uru_rt"
  end
end
