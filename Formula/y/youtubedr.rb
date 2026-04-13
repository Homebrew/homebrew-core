class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/refs/tags/v2.10.6.tar.gz"
  sha256 "c334c04c07c3576e911d78b65b068b574e81e33e385f63a86b4862022391240d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "049accac2a24feea5955585770e6dbdf33094ac2b5d2b72272c99066bab42db2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "049accac2a24feea5955585770e6dbdf33094ac2b5d2b72272c99066bab42db2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "049accac2a24feea5955585770e6dbdf33094ac2b5d2b72272c99066bab42db2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebaa5b1f556aae997a5f09774620f28cda593faf13cf150db364ac1f070babe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2e1ef375afceeace7ee6847b8abb5c65e33b434e79211e1e7b5ed7f1f6d8e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9fab3a1306590624f89889c85218e5e89b0a899b158a048a96a808b55955005"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/youtubedr"

    generate_completions_from_executable(bin/"youtubedr", shell_parameter_format: :cobra)
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch?v=pOtd1cbOP7k 2>&1")
    if $CHILD_STATUS.exitstatus.nonzero? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      # CI runners can be blocked by YouTube, https://github.com/kkdai/youtube/issues/336
      assert_match "can't bypass age restriction:", output
    else
      info_output = output.split("\n")
      assert_match "Title:       History of homebrew-core", info_output[0]
      assert_match "Author:      Rui Chen", info_output[1]
      assert_match "Duration:    13m15s", info_output[2]
    end
  end
end
