class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/0.12.10.tar.gz"
  sha256 "8dd05033aed9a00cb30ab2b454b5709987799e187f298b5817c8f2c8e37ecaf6"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25e86b2a90a05442c7e883447d5139fed351bf0c24a1110def35d3cf3130c028"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25e86b2a90a05442c7e883447d5139fed351bf0c24a1110def35d3cf3130c028"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25e86b2a90a05442c7e883447d5139fed351bf0c24a1110def35d3cf3130c028"
    sha256 cellar: :any_skip_relocation, ventura:        "626b79f4e43c94b0032b7c96971205441e54988955e8cbc741ec380d45ce17f1"
    sha256 cellar: :any_skip_relocation, monterey:       "626b79f4e43c94b0032b7c96971205441e54988955e8cbc741ec380d45ce17f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "626b79f4e43c94b0032b7c96971205441e54988955e8cbc741ec380d45ce17f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51e41cb587b634237268bf413e3e8b57925c1a55002598a343f9c7bdd41d7354"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/ssh-vault/main.go"
  end

  test do
    output = pipe_output("#{bin}/ssh-vault -u new create", "hi")
    fingerprint = output.split("\n").first.split(";").last
    cmd = "#{bin}/ssh-vault -k https://ssh-keys.online/key/#{fingerprint} view"
    output = pipe_output(cmd, output, 0)
    assert_equal "hi", output.chomp
  end
end
