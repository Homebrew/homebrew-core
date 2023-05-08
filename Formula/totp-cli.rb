class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/v1.3.3.tar.gz"
  sha256 "089e8e5cf8666a52e1318cc640d8885910593840d8965bd3d445ff7bede6be8c"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81c57fed7a750a9b0d32b6a6649b0048b71b167036893a54b9e6dcd6af4cafea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81c57fed7a750a9b0d32b6a6649b0048b71b167036893a54b9e6dcd6af4cafea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81c57fed7a750a9b0d32b6a6649b0048b71b167036893a54b9e6dcd6af4cafea"
    sha256 cellar: :any_skip_relocation, ventura:        "887f5cbb5855606f7d020c44c44118835492f832b8e984bdb98ece7557a741c3"
    sha256 cellar: :any_skip_relocation, monterey:       "887f5cbb5855606f7d020c44c44118835492f832b8e984bdb98ece7557a741c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "887f5cbb5855606f7d020c44c44118835492f832b8e984bdb98ece7557a741c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f0d747e1ecdcb1b56896b608aff1b019a554799ce75bb0268a34d53d30030b1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    zsh_completion.install "_totp-cli"
  end

  test do
    assert_match "generate", shell_output("#{bin}/totp-cli help")
    assert_match "storage error", pipe_output("#{bin}/totp-cli list 2>&1", "")
  end
end
