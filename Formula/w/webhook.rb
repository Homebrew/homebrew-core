class Webhook < Formula
  desc "Lightweight, configurable incoming webhook server"
  homepage "https://github.com/adnanh/webhook"
  url "https://github.com/adnanh/webhook/archive/refs/tags/2.8.3.tar.gz"
  sha256 "5bfb3d9efd75d33bfee81fb8dae935178f42689fe0165fc1f5c5a312a0162541"
  license "MIT"
  head "https://github.com/adnanh/webhook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e981d57e5b548be17004dc598f7bfe689c723c0b4ce3558c97e47790ca4e2c49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e981d57e5b548be17004dc598f7bfe689c723c0b4ce3558c97e47790ca4e2c49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e981d57e5b548be17004dc598f7bfe689c723c0b4ce3558c97e47790ca4e2c49"
    sha256 cellar: :any_skip_relocation, sonoma:        "e855bcac49d862a81d538245bca6ec142db97abae337d83f9749db436556f683"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "795d2ced7d92d633a39ee8f94851dc480e92576d5f36a0bcedc593939924ae7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d34f9a2f7294e5ddf78166b5c971e107aaa9a21bdc79425fed4d779664021567"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hooks.yaml").write <<~YAML
      - id: test
        execute-command: /bin/sh
        command-working-directory: "#{testpath}"
        pass-arguments-to-command:
        - source: string
          name: -c
        - source: string
          name: "pwd > out.txt"
    YAML

    port = free_port
    spawn bin/"webhook", "-hooks", "hooks.yaml", "-port", port.to_s
    sleep 1

    system "curl", "localhost:#{port}/hooks/test"
    sleep 1
    assert_equal testpath.to_s, (testpath/"out.txt").read.chomp
  end
end
