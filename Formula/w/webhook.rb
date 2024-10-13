class Webhook < Formula
  desc "Lightweight, configurable incoming webhook server"
  homepage "https://github.com/adnanh/webhook"
  url "https://github.com/adnanh/webhook/archive/refs/tags/2.8.1.tar.gz"
  sha256 "a1e3eb2231e5631ebb374b76a79c3bac9cbdc7010974395e2d5e4e2e62ffd187"
  license "MIT"
  head "https://github.com/adnanh/webhook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f06296f12373497182c9b20aae699a342a8ae7de176bafa4fdd4d363a2398c02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc567cc60391ce928df72e3e2ef625e77ad1707e03eb66f6213916cec614e4fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17ab323f0bddf3df15751ab8e81bdb8dc9313d86f8885c641725e5bff5def2e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17ab323f0bddf3df15751ab8e81bdb8dc9313d86f8885c641725e5bff5def2e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17ab323f0bddf3df15751ab8e81bdb8dc9313d86f8885c641725e5bff5def2e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "77bd89b8b9ae6eb5a74a166d2616b6f80e80c3c43fcbabe10268aaecec07eb76"
    sha256 cellar: :any_skip_relocation, ventura:        "134b8aaaa2624e496cc11e0ff0f6b6b077d53a7a5fdf75521eac4c4f9d2a6e1f"
    sha256 cellar: :any_skip_relocation, monterey:       "134b8aaaa2624e496cc11e0ff0f6b6b077d53a7a5fdf75521eac4c4f9d2a6e1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "134b8aaaa2624e496cc11e0ff0f6b6b077d53a7a5fdf75521eac4c4f9d2a6e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "234b20e6404e53867004ae3a96ea21e59cdf2c72c79a00175193560f61363eae"
  end

  depends_on "go" => :build

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
