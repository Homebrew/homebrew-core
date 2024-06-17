class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev"
  url "https://github.com/semihalev/sdns/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "ce05b82ff42015ab4c4aea3332c35568a1a65c43d23350b845af21d3f195547e"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccfce9784c9cd606a6bde0b291a5a5e8624cb510b57330a68b714dd707e2ea2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66d5d60257c3cecca9439f494f3f1b13d51209dd67d53325910674d581fe9efd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ebccb0e1e6337f15598400d33f1f2c0878e8771da935f8ccbc8115d773be34b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c0561c5c503d21697071d0fb690b79dc6e629778c3f3e2978bfdad008413805"
    sha256 cellar: :any_skip_relocation, ventura:        "5d8ead7596c7019b08343de9252bd66c59bf46340b80f5cb600833584014448a"
    sha256 cellar: :any_skip_relocation, monterey:       "6b4863b33896de4b439513dfbc4c35c0fdee8a9a1e631f9a40a456711517e89d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5188b90cff22adcd0d0f751c95b71ed4bf3416a9f98c4a36b8da3c03c3de07d"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  service do
    run [opt_bin/"sdns", "-config", etc/"sdns.conf"]
    keep_alive true
    require_root true
    error_log_path var/"log/sdns.log"
    log_path var/"log/sdns.log"
    working_dir opt_prefix
  end

  test do
    fork do
      exec bin/"sdns", "-config", testpath/"sdns.conf"
    end
    sleep(2)
    assert_predicate testpath/"sdns.conf", :exist?
  end
end
