class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/tctl/archive/v1.18.0.tar.gz"
  sha256 "46d9bcd8c011205b81f4564023267638ddc1be64a28c61d5c531d0c60af1ad43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23306dba780b51edd53f72c5b351826485932cbf80efa3419684d06ffedfdaf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e62d9e56770170c73542750d0e0673450d329ac4cc1b82cb09137c505afec5ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b338afaf531528c54a443aaa53f9bd858e763fb2c731041005408844121a814c"
    sha256 cellar: :any_skip_relocation, ventura:        "f25060e666c9f4934f9cdc40d113c73ac89ee94a684dc8fa8232f8c208164c8b"
    sha256 cellar: :any_skip_relocation, monterey:       "8b4202cc9e1cdc7cab5f877f1db859bbd4c2ad5f968e2caee6ef24bcaf22f500"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee71c8e3cdd32bd0ac60f8773798be5afd3817e850c20a799cf2c5a6a35c9b02"
    sha256 cellar: :any_skip_relocation, catalina:       "a329194b90331faf0337f21e03c3b95fbc4a1603a9cbef31af8377e84261cf29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3044d16c588df32845253e6c720d651d6f4471d36a54a2c10503d99759b3fa3a"
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
