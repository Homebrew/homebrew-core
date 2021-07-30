class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.2.11.tar.gz"
  sha256 "000965cd009f882e25f218a1eb696dd0733d9e504e994f17ac490d4741a77d8e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f2fdb55a02a3130740dcb7b14043752f5ec5fce8275686bd9d7f8e7c52697f29"
    sha256 cellar: :any_skip_relocation, big_sur:       "507c37b5cf8677c97131c555f66db1f3a4f67941b2b45fbe08624a2b057f5440"
    sha256 cellar: :any_skip_relocation, catalina:      "4dad8009eb32f1dd8422315fc37adfe6418fad14c2d6fa6575c1cadd85d044fa"
    sha256 cellar: :any_skip_relocation, mojave:        "374f959e627e16e46936a4a08fa49672c9e3aa3fe669bd7e55f3b6d140408954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35dd3de9cc36b7ce89bf2c6a03c3f509fe5870e7d4998393c319f5f3caa08aed"
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
