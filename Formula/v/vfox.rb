class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.lhan.me"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "8051374cd4c7fedd740c50e8bcf53abb47bf717d4ce0b49639c2ae291fc04584"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50cb8a7fb207f0ae12d588444fbd9894f5dd69c9ac0b56eec33edaadd0160015"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecff56093e3999ac9d23e8056ae58d1d40848371084dbf6d94883d6e8aa702b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4a8a9b3dff0e01dff1f6063313f3ed13e9d4ae9adfa308e2cf2c8689e01887d"
    sha256 cellar: :any_skip_relocation, sonoma:         "02d36c029a01babbb5a39d0c4cf961cb40f538aa389e39738fc857a94080318b"
    sha256 cellar: :any_skip_relocation, ventura:        "b80fea3c749846604329c96ea2ae5d50b0157ce9be8adc64564c2e0d576cd3d9"
    sha256 cellar: :any_skip_relocation, monterey:       "0cfd6b37dac358d97b997cbc7de39a2c82ae12727718f18477bbb5eeac035d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1408d26fb6a3623f8f0b851e8273e597ca902c54ba40941fa1e11bd27f6d006"
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
