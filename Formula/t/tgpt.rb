class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https://github.com/aandrew-me/tgpt"
  url "https://github.com/aandrew-me/tgpt/archive/refs/tags/v2.9.6.tar.gz"
  sha256 "6800b06059de1f5bab2aa3bbf61c3d43ec63498a9dccb7a4918e7f8790c04bd8"
  license "GPL-3.0-only"
  head "https://github.com/aandrew-me/tgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "163aa59bc4dd9c67e3ce54511a684e320a601918eb72d8f472d1eea2aba8b119"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "163aa59bc4dd9c67e3ce54511a684e320a601918eb72d8f472d1eea2aba8b119"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "163aa59bc4dd9c67e3ce54511a684e320a601918eb72d8f472d1eea2aba8b119"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c38b7cb01d247c012fdb613946a14aa4b7131a6e159f9e58c198938e898e831"
    sha256 cellar: :any_skip_relocation, ventura:       "4c38b7cb01d247c012fdb613946a14aa4b7131a6e159f9e58c198938e898e831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2593ebb991c8ee46269554aea50ec20af8fd15c2465a08a2570e792d9afaa948"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tgpt --version")

    output = shell_output("#{bin}/tgpt --provider pollinations \"What is 1+1\"")
    assert_match "1 + 1 equals 2.", output
  end
end
