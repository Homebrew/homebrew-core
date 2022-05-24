class Webhook < Formula
  desc "Lightweight, configurable incoming webhook server"
  homepage "https://github.com/adnanh/webhook"
  url "https://github.com/adnanh/webhook/archive/2.8.0.tar.gz"
  sha256 "c521558083f96bcefef16575a6f3f98ac79c0160fd0073be5e76d6645e068398"
  license "MIT"
  head "https://github.com/adnanh/webhook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a243c7fe554c0380da0f68556ea1f1613b1847e94a4d21e89b5fe1a38e62b61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e77443d3500d2cd479cf3b326c66cc5c59a7009ddb63f2fb3492488e7b3412c"
    sha256 cellar: :any_skip_relocation, monterey:       "135ca549d05cdf512acded9f75387cbe1a48969bcbcb75fd1dd3dfd247c0e61d"
    sha256 cellar: :any_skip_relocation, big_sur:        "836ee3a10e87e2208f0bc7f9e124b4cb51d0aa3bba16f76e835c4116836c2cf0"
    sha256 cellar: :any_skip_relocation, catalina:       "b4a117234e85237fd2bf36fe7ec4176a773608b4d50044961f82874337c9cc6f"
    sha256 cellar: :any_skip_relocation, mojave:         "9f1f89d07d6b764601887c316900072e4d599d254eb065840fca9b11562ce2cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b9d7fe8bda4f6a5f69d04d48230a8b17ad61d4544a07433a92ffa4abbc7c3a4"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"hooks.yaml").write <<~EOS
      - id: test
        execute-command: /bin/sh
        command-working-directory: "#{testpath}"
        pass-arguments-to-command:
        - source: string
          name: -c
        - source: string
          name: "pwd > out.txt"
    EOS

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
