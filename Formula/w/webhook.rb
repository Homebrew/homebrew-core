class Webhook < Formula
  desc "Lightweight, configurable incoming webhook server"
  homepage "https://github.com/adnanh/webhook"
  url "https://github.com/adnanh/webhook/archive/refs/tags/2.8.2.tar.gz"
  sha256 "c233a810effc24b5ed5653f4fa82152f288ec937d5744a339f7066a6cbccc565"
  license "MIT"
  head "https://github.com/adnanh/webhook.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "353fae094f87012e6168a3c05d23775364567e9b77e23dadaddc6934de132687"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "353fae094f87012e6168a3c05d23775364567e9b77e23dadaddc6934de132687"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "353fae094f87012e6168a3c05d23775364567e9b77e23dadaddc6934de132687"
    sha256 cellar: :any_skip_relocation, sonoma:        "93093d997e626387ef2ca21b6e854d2b04f3a974c144d316db61f924f2eb4546"
    sha256 cellar: :any_skip_relocation, ventura:       "93093d997e626387ef2ca21b6e854d2b04f3a974c144d316db61f924f2eb4546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9041e5e55f02a911e3203d13432b83aa72bfe5fc3869b1f81ac4639a1976c31c"
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
    fork do
      exec bin/"webhook", "-hooks", "hooks.yaml", "-port", port.to_s
    end
    sleep 1

    system "curl", "localhost:#{port}/hooks/test"
    sleep 1
    assert_equal testpath.to_s, (testpath/"out.txt").read.chomp
  end
end
