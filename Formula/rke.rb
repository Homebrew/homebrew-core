class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.4.tar.gz"
  sha256 "97d56fb2e0e8b221c36ab66559a84bd2a9af11f9b8d69c959bd9c9b9e57311af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9635da12c5b725c67a8e0ec582b745408bf41414d5fabb953466f495bc99a0e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54dd3e031cbca601ec75240785e94809d424969dca5a10412ebe4116fcb8e608"
    sha256 cellar: :any_skip_relocation, monterey:       "034a0854c3f2e01814faec2801f7c2d131be8e242971dcfdbbe9bcd10b739a83"
    sha256 cellar: :any_skip_relocation, big_sur:        "df8b921f46ab02fdf8f8f60501b102dd95c200e30418a3128c1c48957e5cf2f5"
    sha256 cellar: :any_skip_relocation, catalina:       "81591c7c14336b0e7a560b27c57d4c578c5f8154ed82db3b63ea882c00eb3ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5846f771c774c1813c91388904e7ec89b04c3f6445654c1941fcbff6cb04b0da"
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
