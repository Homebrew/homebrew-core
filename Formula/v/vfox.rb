class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  # homepage site issue report, https://github.com/version-fox/vfox/issues/426
  homepage "https://github.com/version-fox/vfox"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "f70ea9d2d4bf209dab839da91b8ddbcc7113c1f3e161eb1c8418fb1b9b4d3338"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13645325445b061c993edbf6bbd288bd3bbef97bc574fbb64a604a47a5cf187a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79565f604f7c981e922efd426816085e22446ddde1e7484916d00858a19ec0d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84fc5c5014a86f6a5e4eb506abc5b505330c8f2571f549e689290ad9bfde841f"
    sha256 cellar: :any_skip_relocation, sonoma:        "104c34110a53b74546ebefa64801afacd75a96dd4f790e31a5a59328362787fa"
    sha256 cellar: :any_skip_relocation, ventura:       "b0b0b1af20779c411206d3c205799050fa6b7cf7352996d541044a605cec6c93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b194da09f35b780dfea89a8e346a388e52e1e83c9f2a6d33fd4d4499bb09b18e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "completions/bash_autocomplete" => "vfox"
    zsh_completion.install "completions/zsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfox --version")

    system bin/"vfox", "add", "golang"
    output = shell_output(bin/"vfox info golang")
    assert_match "Golang plugin, https://go.dev/dl/", output
  end
end
