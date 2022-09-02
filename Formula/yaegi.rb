class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/v0.14.2.tar.gz"
  sha256 "78f69e7a2de98b3ea23b05385d3da9cf98b967a398b2af9545b9bba48533ea46"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7211fbefe80c40e54eaf65cceb64718010588f932c8ed5527e1bb712e0f3e4c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "820d324ff8e8702960bde57a39c190205319f2abe62ce61f9de9dc12ca98df09"
    sha256 cellar: :any_skip_relocation, monterey:       "fe68264780b68840cb23d79f63fdd4a92f07b11ac6889d1c2295bd3e7d9b406f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0ef54440f79af234a50458b3eb7f2339169c6af7defb33c3f8ee9676fcfd869"
    sha256 cellar: :any_skip_relocation, catalina:       "26f0b08e221dc6e39963b3e6824fa937136eb3e0764fafd5a7c5b232abc0fc91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f84a04341fce3a21cf87d4786d0fb7cb530c41f53a3ce8d2cc0a68cb1686ffb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
