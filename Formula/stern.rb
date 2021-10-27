class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.20.1.tar.gz"
  sha256 "941bd4754b0efa9d0692edcae2eb97362f6caa5ccc5aba1be6b4aab0c579bf47"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cbdb7a368cd3207ac29cfe6fc4fb4661560515e493235fe31a248ab232ebc07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5213cb7a44475a0566124a1097211e32ea9b790b7b676039829a5e8a6214e4d2"
    sha256 cellar: :any_skip_relocation, monterey:       "31f5c74f1b3345711656f07efc338edb4eb6c99d5099fc81c7509dc4d3aef27f"
    sha256 cellar: :any_skip_relocation, big_sur:        "56b0796bcd302d62e27cb804b81326ba4deaed878d5c75500df6a1fd92d7891d"
    sha256 cellar: :any_skip_relocation, catalina:       "83f30238e2facaf9f7ee0b075984d10d7eea562b18a3382eeedc022201926702"
    sha256 cellar: :any_skip_relocation, mojave:         "7efb9e59a6eb59045d64fabedc71665c948a777e6cb35d0b678d113f934d4916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "829512e281e9b5d0be29d5b464d11af158f2902c8ce06bd099a97707f7814fda"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    output = Utils.safe_popen_read("#{bin}/stern", "--completion=bash")
    (bash_completion/"stern").write output

    output = Utils.safe_popen_read("#{bin}/stern", "--completion=zsh")
    (zsh_completion/"_stern").write output

    output = Utils.safe_popen_read("#{bin}/stern", "--completion=fish")
    (fish_completion/"stern.fish").write output
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
