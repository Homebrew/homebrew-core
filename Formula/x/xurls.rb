class Xurls < Formula
  desc "Extract urls from text"
  homepage "https://github.com/mvdan/xurls"
  url "https://github.com/mvdan/xurls/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "476d92a0416fee965f928180a950691b85dbb8d11efc3dc7f795ecc106c76075"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/xurls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22c2b64793e739cc7e0f4c74200696d92dbb5844beb0cdcbab647c770991ee02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5b5a4fca9fccb9162ae07c8d883401d049a1823faf90766628480cebba4aa1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5b5a4fca9fccb9162ae07c8d883401d049a1823faf90766628480cebba4aa1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5b5a4fca9fccb9162ae07c8d883401d049a1823faf90766628480cebba4aa1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "984597d394db29ff5f590173452dfa7333a90aec571508c292f5d7d2cc322edf"
    sha256 cellar: :any_skip_relocation, ventura:       "984597d394db29ff5f590173452dfa7333a90aec571508c292f5d7d2cc322edf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f5192b2f2074758f78e7b48523611b30496e269da961abdeadf017c3afe57fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff7c2bd2e39eda3aa3d5fcf116a62ce740d594e4408a3166c9f6c66157ace5db"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/xurls"
  end

  test do
    output = pipe_output(bin/"xurls", "Brew test with https://brew.sh.")
    assert_equal "https://brew.sh", output.chomp

    output = pipe_output("#{bin}/xurls --fix", "Brew test with http://brew.sh.")
    assert_equal "Brew test with https://brew.sh/.", output.chomp
  end
end
