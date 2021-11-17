class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "314711f616ea71613fe883fe579e7d3bc0051f540f27c7925a1ce6a0ece69378"
  license "MIT"

  depends_on "go" => :build
  depends_on "tmux" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    (testpath/"test.yml").write <<~EOF
      session: homebrew-test-session

      windows:
        - name: the-main-session
          commands:
          - echo hi
          - true
          - false
    EOF

    require "pty"

    PTY.spawn "#{bin}/smug start --file test.yml"
    PTY.spawn "#{bin}/smug stop --file test.yml"
  end
end
