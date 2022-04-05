class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/tctl/archive/v1.16.0.tar.gz"
  sha256 "17a166ffb12256a4131fb4344ff2abdcb7aa2f3473e6fd216fdbe454a0ce2238"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76cd7f59f77a79d9375c9fc265564cf794d755f2260ea9de02b099fb5e2af450"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cb7d6bca382a81d953cc3b4e9b7b7cf9ba11ac0b9ae4072b9e16155e67fe4a6"
    sha256 cellar: :any_skip_relocation, monterey:       "831471b4ef711a4b619b041742fb54161a12257b1a94ac6273d9e675bd3a5224"
    sha256 cellar: :any_skip_relocation, big_sur:        "a87bc5505e2a445692d774fbc3f69fa4c2ed4f048ad528135775cdaf07d4d102"
    sha256 cellar: :any_skip_relocation, catalina:       "b24f354ca248461d44afce69f791de5ebbbb572a5a33d022ff1d2a6295844dc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d71039ef6650e94495e23c7954a567f34c695f7d39f7a28b08b2e802a5a5b358"
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
