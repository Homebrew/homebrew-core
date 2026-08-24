class VultrCli < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://github.com/vultr/vultr-cli/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "e29be650393530c424ea301b6d39092d2daceaa8059a4096bcfa3bbd54828fe2"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3ca4acd19f2d797ec6a2133a3465c8fb214d2fc15e2510171affb6463c23916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3ca4acd19f2d797ec6a2133a3465c8fb214d2fc15e2510171affb6463c23916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3ca4acd19f2d797ec6a2133a3465c8fb214d2fc15e2510171affb6463c23916"
    sha256 cellar: :any_skip_relocation, sonoma:        "efddbb66525c893ec92f14b7d7d4d450838bc1b552cb0cd3b162575c56831b6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f427f82cf22daa0545849080fb82955b3a893911cba9bae8d965982d20aa5d48"
    sha256 cellar: :any,                 x86_64_linux:  "31435d83d3d4d71f45fa29b00d4cabfb213718a2e2471597836dde275e3b6677"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"vultr-cli", shell_parameter_format: :cobra)

    # TODO: consider deprecating old name and then remove after a couple releases
    bin.install_symlink "vultr-cli" => "vultr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vultr-cli version")
    assert_match "Custom", shell_output("#{bin}/vultr-cli os list")
    assert_match "-F __start_vultr-cli",
                 shell_output("bash -c \"source #{bash_completion}/vultr-cli && complete -p vultr-cli\"")
  end
end
