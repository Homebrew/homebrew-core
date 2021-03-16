class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.10.0.tar.gz"
  sha256 "5a707d68cd03ade95b854ea127505ebc5d31d6a9adfe72dd34ce89f168ac21d1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3586c5479891017ca0a7cb973fde54079581c4baf1b0549c4871573749178cf0"
    sha256 cellar: :any_skip_relocation, big_sur:       "3cd73bcc3a82c7e5a32c9fb61c8310f242e8794d88d1aa35dab5da5145a4b111"
    sha256 cellar: :any_skip_relocation, catalina:      "2eef7c5a53ea897bc83f13bcd0355f4a1ea4761a66e36bf397da7ed346030036"
    sha256 cellar: :any_skip_relocation, mojave:        "220adb852f880ece00d089358eece8c22d43898117b8fba901db9ef6fcb6de7f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
