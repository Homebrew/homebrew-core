class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/v1.7.0.tar.gz"
  sha256 "61bbf01c35eece0b26d986ac0d9d684a7d42f842dbc30db188ac4f9fac650fba"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f367c9ebfe4832d98973c36b4491b7f9e9e57531f313f7873f8587f282ae0577"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8763b90a3964b239bd61422bd124b137d27072c8f7a74f594cd20afecc9e2b0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55ca081657030b33bab9481674a7c153981bd7acd87d7ab4b1ebd42234ca7bbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa31731be6cc5b518ae55d9491739b6487135ff4e3aaf9cc96d9fd6fcdba4da2"
    sha256 cellar: :any_skip_relocation, ventura:        "a91bf36339466014503bebf66ee9f0f37eb735be03e4aa9baf148bc9ad4ca8e3"
    sha256 cellar: :any_skip_relocation, monterey:       "4fcfb6bbcd375bfad504275a10fe5f4a99bbaf4994ec03e4597b6f026059a300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f966704cf03b60c02d4c193d160c5cc6f8f9c2f599e0a50092400f2f477223f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "autocomplete/bash_autocomplete" => "totp-cli"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_totp-cli"
  end

  test do
    assert_match "generate", shell_output("#{bin}/totp-cli help")
    assert_match "storage error", pipe_output("#{bin}/totp-cli list 2>&1", "")
  end
end
