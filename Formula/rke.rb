class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.7.tar.gz"
  sha256 "5b729b71693434827ebeb4e3955bcc149f3f7280fb1e6600aa1872317eb2785d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7e4d118b29feff7f3297d8f7db7b1813f43c1503451eb55e8de6e94f1e85865"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7376fcb805bc0bdc8be3f87e19de562d9a99e2a475b9abd5b2af39179e5b244"
    sha256 cellar: :any_skip_relocation, monterey:       "cf04051151fc21cb42759a7c14c1dfe0c3aaa91c5f161f81c39a1ccf6862c3ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb77b1999bdfbf88724a8ba41140cf0aa9588f63b8337afbd2896326134a1515"
    sha256 cellar: :any_skip_relocation, catalina:       "d63fcaf1a56e15addbfee5ec03372919e39d2242b984e464b1fcbd5999e861bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "406af62d175ef9560511b4d2027702b446599b123f920560ea9e1a4d2977720c"
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
