class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "4e794c8ed578c0b64167b5265a26763ce5f949be906adf81acf0e07f795f20e1"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93daea770534408b6f6671192610c6be4f376abbe56d3da8e8bf03248afa060d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c250903f6d4c152a5b3f206830a1723ab99113543b11392bd3fc766118df66a"
    sha256 cellar: :any_skip_relocation, monterey:       "c5cfe833c9e9846ab5b353e37a92dbe070b160c668d661f2a236d38dacb732f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "082f1bd34f0ff02e7aee3603822f81974fadfa08a0270be688c614fee6a46faf"
    sha256 cellar: :any_skip_relocation, catalina:       "f946c9c98ec2eb51f834896394c835df8360568dbe1752f7caa1250b4b3c32e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4c04b2fb241db4c93336ab4b63ccf6aa579ecc0091b136727340a71c2841fb2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/getoutreach/gobox/pkg/app.Version=v#{version} -X github.com/getoutreach/gobox/pkg/updater/Disabled=true"),
      "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_predicate testpath/"stencil.lock", :exist?
  end
end
