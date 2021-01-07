class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.2.4.tar.gz"
  sha256 "834ddf2a1cf567fc903579a6b1ac76ba73ebc750ed1759df6fe852d95ab2edde"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fc58331c842addfc9a0732fdbc3d823e38a493d2f9c79e3449efe635fc8f36e" => :big_sur
    sha256 "28067f58d0488728c9184040cb1916eb30a955b73f51114e9411db846476201b" => :arm64_big_sur
    sha256 "dac0a326cfff5070dd3c7fc6148859c6030bbefe253fa5ca9214ba61d80f8ee2" => :catalina
    sha256 "4058b540d3e20f3b37b3ef412bede3cf562aa2f5d8d50029f07ae5e579b70dd1" => :mojave
    sha256 "237a4ac97ad834d7f821183e71f29861d78a60dfa723e0eddb233ef85147df3a" => :high_sierra
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
