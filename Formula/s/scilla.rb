class Scilla < Formula
  desc "DNS, subdomain, port, directory enumeration tool"
  homepage "https://github.com/edoardottt/scilla"
  url "https://github.com/edoardottt/scilla/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "cccf86bc9c0ed70c2322d2921b06fa51905bdfb65ab51afe9c0df52411596cbb"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/scilla.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69baec3497812a02e6696b0461bb9440ff58b94e12d5bcf31e99c622ef808527"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "039527494f3f17c66014aec9d96864c4b4a8b0b872e17ac7c0fac2adf178f4ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb5c3d6084a64a174792e865212d082d9b401a58468b49211558620458052dfc"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae371c2742878f593a9ae762bb8a71aa209992cbcd11fe6c5c622cfbab85bbcd"
    sha256 cellar: :any_skip_relocation, ventura:        "37eb1ecba2eac939a47805c4ddc17fe0453e51b88d06a7904f1d3e09e0a4a473"
    sha256 cellar: :any_skip_relocation, monterey:       "6c7c2ea4227c1c39157fccb3472c11a84b79946b77da99714134ca36ddb4d732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03a8f2960436b22aebd0642db667c9d60e11fd70cb8f294f3407de6ed5d98e2b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/scilla"
  end

  test do
    output = shell_output("#{bin}/scilla dns -target brew.sh")
    assert_match "[+]FOUND brew.sh IN CNAME: brew.sh.", output
  end
end
