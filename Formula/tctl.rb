class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/tctl/archive/v1.17.1.tar.gz"
  sha256 "1450e53574bb0e19261683f036d9d5bde9db8e430c058883376d37de10797a45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c2550de462599659927e356e8ff797ddd9f4fbda74bff8ca53fa8425f350f45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20eba19b7c20540196dc3da0ec1d944cbba2dfb77fb00ccb23340c8935d10b53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a17404177e5ca0e2460c77c2c6a2abe16eedb104a1aafb4a9f0bbfbfcc4f9f0"
    sha256 cellar: :any_skip_relocation, ventura:        "12dc09bbbded177153e11fa11ca099b1338d974a87962117296d4e11c42b975b"
    sha256 cellar: :any_skip_relocation, monterey:       "02a36c19f1fcbfec7efdc907283cfa5c82e86b1c81ff83d548be1067ce1f4eee"
    sha256 cellar: :any_skip_relocation, big_sur:        "19705442886fdfd641c033249b56a3508488fa08a8e1cac59250ea2334f486cd"
    sha256 cellar: :any_skip_relocation, catalina:       "5f211e13df3e4bcf1553114a14668c25901f426c385b207ace42b36e47ee2be8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0443d54686a4cb5de086c48bc7af4581cbfb5948e6243c41e7828dcd5db07fb5"
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
