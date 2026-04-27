class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "79d3bbcb8c3241dceb83dd3fdb7ac3bce4c538e0808b6a6cb3ef301d110ce1e9"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bad83c7430ad17df98d469126f938b64c02e8391d6d433a9ddcaade179c59206"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bad83c7430ad17df98d469126f938b64c02e8391d6d433a9ddcaade179c59206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bad83c7430ad17df98d469126f938b64c02e8391d6d433a9ddcaade179c59206"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ddf79b3a5f00047199d600f4ea3bf73df02c801033de9327ce82fc9b19b6196"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5336172c51b94dd3aeea0d9be66e0acfeefb32bceb2b459fcc24179d8808bde7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c036deda29a95fa69c59577394520728c5d086976245ab99903f79ae067dd259"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"sesh", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end
