class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/tctl/archive/v1.18.0.tar.gz"
  sha256 "46d9bcd8c011205b81f4564023267638ddc1be64a28c61d5c531d0c60af1ad43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd1873694be159397804949a0c67571ac1e4498d171a14c77df7e0358a2b4952"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd1873694be159397804949a0c67571ac1e4498d171a14c77df7e0358a2b4952"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd1873694be159397804949a0c67571ac1e4498d171a14c77df7e0358a2b4952"
    sha256 cellar: :any_skip_relocation, ventura:        "f2620cc94d86b2a901f7732f0998abc75b75bae3cf6b8e536044c1e14f1112e5"
    sha256 cellar: :any_skip_relocation, monterey:       "f2620cc94d86b2a901f7732f0998abc75b75bae3cf6b8e536044c1e14f1112e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2620cc94d86b2a901f7732f0998abc75b75bae3cf6b8e536044c1e14f1112e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad918854bbf7b4436d575d9cd5da9a7b7f492feed7ae96c4630b4e41ebb034bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tctl/main.go"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"tctl-authorization-plugin",
      "./cmd/plugins/tctl-authorization-plugin/main.go"
  end

  test do
    # Given tctl is pointless without a server, not much intersting to test here.
    run_output = shell_output("#{bin}/tctl --version 2>&1")
    assert_match "tctl version", run_output

    run_output = shell_output("#{bin}/tctl --ad 192.0.2.0:1234 n l 2>&1", 1)
    assert_match "rpc error", run_output
  end
end
