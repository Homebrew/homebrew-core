class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.2.4.tar.gz"
  sha256 "834ddf2a1cf567fc903579a6b1ac76ba73ebc750ed1759df6fe852d95ab2edde"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "96bb6aa5912cc4a4217cc3d55fbe1ad5144bdc6bc6ac698b08a66fe0f59077ad" => :big_sur
    sha256 "ef38c121ff3c2cf286ecb89d7a5951d83eb6097f919b768e0cffc950f9634ffc" => :arm64_big_sur
    sha256 "7054d5ef96907055b9ec1727ddeafcaa7d0457a8e7fa667cc8bdd190b1d374b5" => :catalina
    sha256 "10e68db9174d7805e85c699adba15ce6aded5aca025c8204c9ae5260b8d01dcb" => :mojave
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
