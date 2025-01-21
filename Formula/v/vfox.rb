class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.lhan.me"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "741233cb5fa7bd10cab117713816a1771484db7149fbe87b294bc09072e15d33"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3007b40e4f8f30c6cda56a405304439138f3c070442d5bad6fb99c93dd99290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3007b40e4f8f30c6cda56a405304439138f3c070442d5bad6fb99c93dd99290"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3007b40e4f8f30c6cda56a405304439138f3c070442d5bad6fb99c93dd99290"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfd76fb771686f2cbdf57e8a53f9dcb33d5429ce63e44d39ae0f0dd821bf3c98"
    sha256 cellar: :any_skip_relocation, ventura:       "cfd76fb771686f2cbdf57e8a53f9dcb33d5429ce63e44d39ae0f0dd821bf3c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3507aac6a17e567affe87f32061b3f300bea26e3f353199aad2ff401d894d8a"
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
