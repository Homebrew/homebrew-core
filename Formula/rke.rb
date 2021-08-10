class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.2.11.tar.gz"
  sha256 "000965cd009f882e25f218a1eb696dd0733d9e504e994f17ac490d4741a77d8e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "325252e7159d95004de0eb557659d1479f592877817eecc1ce6dcfde3665140a"
    sha256 cellar: :any_skip_relocation, big_sur:       "ea580e977b241d113a0b184089990df398c4a71de278b269322c0e4aabfc4777"
    sha256 cellar: :any_skip_relocation, catalina:      "f0e271da5d927f5d427f381f7a8b833a0c255fc24e3b6158c3d96d2ebcf0b80a"
    sha256 cellar: :any_skip_relocation, mojave:        "4497e78446a2c02ccc65559f83f4c34bbe6c57125a517e0ea5af5f96720a214b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f156f0cddb0e4311c612cd97076dd577d6b9a99fdc361847f716326db648df40"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
            "-w -X main.VERSION=v#{version}",
            "-o", bin/"rke"
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
